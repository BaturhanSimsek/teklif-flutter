import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/api_client.dart';
import '../constants/api_paths.dart';
import 'outbox_entry.dart';
import 'outbox_repository.dart';

part 'sync_service.g.dart';

@riverpod
SyncService syncService(SyncServiceRef ref) =>
    SyncService(ref.watch(dioProvider), OutboxRepository());

// Outbox'taki bekleyen islemleri internet gelince sunucuya gonderir.
// Idempotency-Key header'i ile double-send korunmasi saglanir.
class SyncService {
  SyncService(this._dio, this._outbox, {this.onConflict}) {
    _watchConnectivity();
  }

  final Dio              _dio;
  final OutboxRepository _outbox;
  // 409 Conflict callback'i — UI dilerse kullaniciya bildirim gosterebilir
  final void Function(OutboxEntry entry, dynamic serverData)? onConflict;
  bool _syncing = false;

  // Connectivity degisikliklerini dinle; internet gelince tetikle
  void _watchConnectivity() {
    Connectivity().onConnectivityChanged.listen((results) {
      final online = results.any((r) => r != ConnectivityResult.none);
      if (online) syncNow();
    });
  }

  // Dis tetikleyiciden (uygulama on plana gelince vb.) cagirilabilir
  Future<SyncResult> syncNow() async {
    if (_syncing) return const SyncResult(synced: 0, failed: 0);
    _syncing = true;

    int synced = 0, failed = 0;

    try {
      final pending = await _outbox.getPending();
      if (pending.isEmpty) return const SyncResult(synced: 0, failed: 0);

      debugPrint('[Sync] ${pending.length} bekleyen islem isleniyor');

      for (final entry in pending) {
        await _outbox.markSyncing(entry.id);
        try {
          await _process(entry);
          await _outbox.markDone(entry.id);
          synced++;
          debugPrint('[Sync] ✓ ${entry.entityType.name} ${entry.operation.name}');
        } on DioException catch (e) {
          if (e.response?.statusCode == 409) {
            // Server Wins: cakisma — yerel islemi iptal et (sunucu versiyonu kazanir)
            await _outbox.markDone(entry.id); // kuyruktan kaldir
            onConflict?.call(entry, e.response?.data);
            debugPrint('[Sync] ⚡ Conflict (Server Wins): ${entry.entityType.name}');
          } else {
            final next = entry.retryCount + 1;
            await _outbox.markFailed(entry.id, e.toString(), next);
            failed++;
            debugPrint('[Sync] ✗ ${entry.entityType.name}: $e (deneme $next)');
          }
        } catch (e) {
          final next = entry.retryCount + 1;
          await _outbox.markFailed(entry.id, e.toString(), next);
          failed++;
          debugPrint('[Sync] ✗ ${entry.entityType.name}: $e (deneme $next)');
        }
      }
    } finally {
      _syncing = false;
    }

    return SyncResult(synced: synced, failed: failed);
  }

  Future<void> _process(OutboxEntry entry) async {
    final payload = jsonDecode(entry.payload) as Map<String, dynamic>;
    final headers = {
      'X-Idempotency-Key': entry.idempotencyKey,
    };

    switch (entry.entityType) {
      case OutboxEntityType.quote:
        await _processQuote(entry.operation, payload, headers);
      case OutboxEntityType.customer:
        await _processCustomer(entry.operation, payload, headers);
    }
  }

  Future<void> _processQuote(
      OutboxOperation op, Map<String, dynamic> payload, Map<String, String> h) async {
    switch (op) {
      case OutboxOperation.create:
        await _dio.post(ApiPaths.quotes, data: payload, options: Options(headers: h));
      case OutboxOperation.update:
        final id = payload['id'] as String;
        await _dio.put(ApiPaths.quoteById(id), data: payload, options: Options(headers: h));
      case OutboxOperation.send:
        final id = payload['id'] as String;
        await _dio.post(ApiPaths.quoteSend(id), options: Options(headers: h));
      case OutboxOperation.delete:
        final id = payload['id'] as String;
        await _dio.delete(ApiPaths.quoteById(id), options: Options(headers: h));
    }
  }

  Future<void> _processCustomer(
      OutboxOperation op, Map<String, dynamic> payload, Map<String, String> h) async {
    switch (op) {
      case OutboxOperation.create:
        await _dio.post(ApiPaths.customers, data: payload, options: Options(headers: h));
      case OutboxOperation.update:
        final id = payload['id'] as String;
        await _dio.put(ApiPaths.customer(id), data: payload, options: Options(headers: h));
      case OutboxOperation.delete:
        final id = payload['id'] as String;
        await _dio.delete(ApiPaths.customer(id), options: Options(headers: h));
      case OutboxOperation.send:
        break;
    }
  }

  Future<int> get pendingCount => _outbox.pendingCount();
}

class SyncResult {
  const SyncResult({required this.synced, required this.failed});
  final int synced;
  final int failed;
  bool get hasWork => synced > 0 || failed > 0;
}
