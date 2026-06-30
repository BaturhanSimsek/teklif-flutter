import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'outbox_entry.dart';
import 'outbox_repository.dart';
import 'package:dio/dio.dart';
import 'dart:convert';

// Workmanager'in cagirdigi top-level callback — isolate'ta calisir,
// provider/BuildContext erisimi yoktur, direkt servisleri kullanir.
@pragma('vm:entry-point')
void backgroundSyncCallback() {
  Workmanager().executeTask((taskName, inputData) async {
    try {
      final outbox  = OutboxRepository();
      final pending = await outbox.getPending();
      if (pending.isEmpty) return Future.value(true);

      debugPrint('[BgSync] ${pending.length} bekleyen islem');

      // Temel Dio instance (auth token SharedPreferences'tan okunabilir
      // ancak background'da auth refresh yapamayiz — token gecerliyse calisir)
      final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 20)));

      // TODO: token okuma eklenecek — simdilik uygulama on plana gelince sync cagirilir
      // background sync sadece token gecerliyse anlamli calisir

      for (final entry in pending) {
        await outbox.markSyncing(entry.id);
        try {
          await _processEntry(entry, dio);
          await outbox.markDone(entry.id);
        } catch (e) {
          final next = entry.retryCount + 1;
          await outbox.markFailed(entry.id, e.toString(), next);
        }
      }

      return Future.value(true);
    } catch (e) {
      debugPrint('[BgSync] Hata: $e');
      return Future.value(false);
    }
  });
}

Future<void> _processEntry(OutboxEntry entry, Dio dio) async {
  final payload = jsonDecode(entry.payload) as Map<String, dynamic>;
  final headers = {'X-Idempotency-Key': entry.idempotencyKey};

  switch (entry.entityType) {
    case OutboxEntityType.quote:
      switch (entry.operation) {
        case OutboxOperation.create:
          await dio.post('/quotes', data: payload,
              options: Options(headers: headers));
        case OutboxOperation.send:
          await dio.post('/quotes/${payload['id']}/send',
              options: Options(headers: headers));
        case OutboxOperation.update:
          await dio.put('/quotes/${payload['id']}', data: payload,
              options: Options(headers: headers));
        case OutboxOperation.delete:
          await dio.delete('/quotes/${payload['id']}',
              options: Options(headers: headers));
      }
    case OutboxEntityType.customer:
      switch (entry.operation) {
        case OutboxOperation.create:
          await dio.post('/customers', data: payload,
              options: Options(headers: headers));
        case OutboxOperation.update:
          await dio.put('/customers/${payload['id']}', data: payload,
              options: Options(headers: headers));
        case OutboxOperation.delete:
          await dio.delete('/customers/${payload['id']}',
              options: Options(headers: headers));
        case OutboxOperation.send:
          break;
      }
  }
}

// Workmanager'i baslat ve periyodik sync gorevi kaydet
Future<void> initBackgroundSync() async {
  await Workmanager().initialize(backgroundSyncCallback);

  // Her 15 dakikada bir kontrol (workmanager minimum 15dk, Android kisitlama)
  await Workmanager().registerPeriodicTask(
    'teklifapp-bg-sync',
    'backgroundSync',
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );
}
