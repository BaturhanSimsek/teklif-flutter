import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// SQLite singleton — Outbox kuyruğu + yerel önbellek tablolarını yönetir.
// Version geçmişi: v1 = başlangıç şeması (outbox, quote_cache, customer_cache)
class LocalDatabase {
  LocalDatabase._();
  static final LocalDatabase instance = LocalDatabase._();

  static Database? _db;

  Future<Database> get db async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'teklifapp.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE outbox (
        id              TEXT PRIMARY KEY,
        entity_type     TEXT NOT NULL,
        operation       TEXT NOT NULL,
        payload         TEXT NOT NULL,
        idempotency_key TEXT NOT NULL UNIQUE,
        status          TEXT NOT NULL DEFAULT 'pending',
        retry_count     INTEGER NOT NULL DEFAULT 0,
        next_retry_at   INTEGER,
        error_message   TEXT,
        created_at      INTEGER NOT NULL,
        synced_at       INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE quote_cache (
        id          TEXT PRIMARY KEY,
        tenant_id   TEXT NOT NULL,
        data        TEXT NOT NULL,
        cached_at   INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE customer_cache (
        id          TEXT PRIMARY KEY,
        tenant_id   TEXT NOT NULL,
        data        TEXT NOT NULL,
        cached_at   INTEGER NOT NULL
      )
    ''');

    await db.execute(
        'CREATE INDEX idx_outbox_status ON outbox(status, created_at)');
    await db.execute(
        'CREATE INDEX idx_outbox_entity ON outbox(entity_type, status)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
          'ALTER TABLE outbox ADD COLUMN next_retry_at INTEGER');
    }
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
