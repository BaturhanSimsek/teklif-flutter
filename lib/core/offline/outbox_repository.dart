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
    final db   = await _db.db;
    final maps = await db.query(
      'outbox',
      where: 'status = ? AND retry_count < ?',
      whereArgs: ['pending', OutboxEntry.maxRetries],
      orderBy: 'entity_type, created_at ASC', // once musteri, sonra teklif
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
    await db.update('outbox',
        {'status': stat, 'retry_count': retryCount, 'error_message': error},
        where: 'id = ?', whereArgs: [id]);
  }

  Future<int> pendingCount() async {
    final db  = await _db.db;
    final res = await db.rawQuery(
        "SELECT COUNT(*) as c FROM outbox WHERE status = 'pending'");
    return (res.first['c'] as int?) ?? 0;
  }
}
