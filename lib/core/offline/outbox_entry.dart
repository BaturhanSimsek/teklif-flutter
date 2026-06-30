enum OutboxOperation { create, update, delete, send }
enum OutboxStatus    { pending, syncing, failed }
enum OutboxEntityType { quote, customer }

class OutboxEntry {
  OutboxEntry({
    required this.id,
    required this.entityType,
    required this.operation,
    required this.payload,
    required this.idempotencyKey,
    this.status = OutboxStatus.pending,
    this.retryCount = 0,
    this.nextRetryAt,
    this.errorMessage,
    required this.createdAt,
    this.syncedAt,
  });

  final String          id;
  final OutboxEntityType entityType;
  final OutboxOperation  operation;
  final String           payload;        // JSON string
  final String           idempotencyKey;
  OutboxStatus           status;
  int                    retryCount;
  DateTime?              nextRetryAt;
  String?                errorMessage;
  final DateTime         createdAt;
  DateTime?              syncedAt;

  // Exponential backoff: 1dk → 2dk → 4dk → 8dk → 16dk → max 30dk
  static Duration backoffFor(int retryCount) {
    final minutes = (1 << retryCount).clamp(1, 30);
    return Duration(minutes: minutes);
  }

  static const maxRetries = 5;

  Map<String, dynamic> toMap() => {
    'id'              : id,
    'entity_type'     : entityType.name,
    'operation'       : operation.name,
    'payload'         : payload,
    'idempotency_key' : idempotencyKey,
    'status'          : status.name,
    'retry_count'     : retryCount,
    'next_retry_at'   : nextRetryAt?.millisecondsSinceEpoch,
    'error_message'   : errorMessage,
    'created_at'      : createdAt.millisecondsSinceEpoch,
    'synced_at'       : syncedAt?.millisecondsSinceEpoch,
  };

  factory OutboxEntry.fromMap(Map<String, dynamic> m) => OutboxEntry(
    id             : m['id'] as String,
    entityType     : OutboxEntityType.values.byName(m['entity_type'] as String),
    operation      : OutboxOperation.values.byName(m['operation'] as String),
    payload        : m['payload'] as String,
    idempotencyKey : m['idempotency_key'] as String,
    status         : OutboxStatus.values.byName(m['status'] as String),
    retryCount     : m['retry_count'] as int,
    nextRetryAt    : m['next_retry_at'] != null
        ? DateTime.fromMillisecondsSinceEpoch(m['next_retry_at'] as int)
        : null,
    errorMessage   : m['error_message'] as String?,
    createdAt      : DateTime.fromMillisecondsSinceEpoch(m['created_at'] as int),
    syncedAt       : m['synced_at'] != null
        ? DateTime.fromMillisecondsSinceEpoch(m['synced_at'] as int)
        : null,
  );
}
