import 'package:sqflite/sqflite.dart';
import 'local_database.dart';
import 'outbox_entry.dart';

class OutboxRepository {
  final _db = LocalDatabase.instance;

  Future<void> add(OutboxEntry entry) async {
    final db = await _db.db;
    await db.insert('outbox', entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<List<OutboxEntry>> getPending() async {
    final db  = await _db.db;
    final now = DateTime.now().millisecondsSinceEpoch;
    // Exponential backoff: next_retry_at null (ilk deneme) veya gecmis ise isle
    final maps = await db.query(
      'outbox',
      where: 'status = ? AND retry_count < ? AND (next_retry_at IS NULL OR next_retry_at <= ?)',
      whereArgs: ['pending', OutboxEntry.maxRetries, now],
      orderBy: 'entity_type, created_at ASC',
    );
    return maps.map(OutboxEntry.fromMap).toList();
  }

  Future<void> markSyncing(String id) async {
    final db = await _db.db;
    await db.update('outbox', {'status': 'syncing'},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> markDone(String id) async {
    final db = await _db.db;
    await db.update('outbox',
        {'status': 'done', 'synced_at': DateTime.now().millisecondsSinceEpoch},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<void> markFailed(String id, String error, int retryCount) async {
    final db   = await _db.db;
    final stat = retryCount >= OutboxEntry.maxRetries ? 'failed' : 'pending';
    // Exponential backoff: sonraki deneme zamanini hesapla
    final nextRetry = retryCount < OutboxEntry.maxRetries
        ? DateTime.now().add(OutboxEntry.backoffFor(retryCount)).millisecondsSinceEpoch
        : null;
    await db.update('outbox', {
      'status'        : stat,
      'retry_count'   : retryCount,
      'next_retry_at' : nextRetry,
      'error_message' : error,
    }, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> pendingCount() async {
    final db  = await _db.db;
    final res = await db.rawQuery(
        "SELECT COUNT(*) as c FROM outbox WHERE status = 'pending'");
    return (res.first['c'] as int?) ?? 0;
  }
}
