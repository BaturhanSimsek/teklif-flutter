import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../api/api_client.dart';
import 'outbox_entry.dart';
import 'outbox_repository.dart';

part 'sync_service.g.dart';

@riverpod
SyncService syncService(SyncServiceRef ref) =>
    SyncService(ref.watch(dioProvider), OutboxRepository());

// Outbox'taki bekleyen islemleri internet gelince sunucuya gonderir.
// Idempotency-Key header'i ile double-send korunmasi saglanir.
class SyncService {
  SyncService(this._dio, this._outbox) {
    _watchConnectivity();
  }

  final Dio              _dio;
  final OutboxRepository _outbox;
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
        await _dio.post('/quotes', data: payload, options: Options(headers: h));
      case OutboxOperation.update:
        final id = payload['id'] as String;
        await _dio.put('/quotes/$id', data: payload, options: Options(headers: h));
      case OutboxOperation.send:
        final id = payload['id'] as String;
        await _dio.post('/quotes/$id/send', options: Options(headers: h));
      case OutboxOperation.delete:
        final id = payload['id'] as String;
        await _dio.delete('/quotes/$id', options: Options(headers: h));
    }
  }

  Future<void> _processCustomer(
      OutboxOperation op, Map<String, dynamic> payload, Map<String, String> h) async {
    switch (op) {
      case OutboxOperation.create:
        await _dio.post('/customers', data: payload, options: Options(headers: h));
      case OutboxOperation.update:
        final id = payload['id'] as String;
        await _dio.put('/customers/$id', data: payload, options: Options(headers: h));
      case OutboxOperation.delete:
        final id = payload['id'] as String;
        await _dio.delete('/customers/$id', options: Options(headers: h));
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
