class KanbanBoard {
  final List<KanbanCard> draft;
  final List<KanbanCard> sent;
  final List<KanbanCard> approved;
  final List<KanbanCard> rejected;
  final List<KanbanCard> expired;

  const KanbanBoard({
    required this.draft,
    required this.sent,
    required this.approved,
    required this.rejected,
    required this.expired,
  });

  factory KanbanBoard.fromJson(Map<String, dynamic> json) => KanbanBoard(
        draft:    _parse(json['draft']),
        sent:     _parse(json['sent']),
        approved: _parse(json['approved']),
        rejected: _parse(json['rejected']),
        expired:  _parse(json['expired']),
      );

  static List<KanbanCard> _parse(dynamic raw) =>
      (raw as List).map((j) => KanbanCard.fromJson(j as Map<String, dynamic>)).toList();
}

class KanbanCard {
  final String    id;
  final String    quoteNumberDisplay;
  final String    customerName;
  final int       status;
  final bool      isApproved;
  final String    currency;
  final double    grandTotal;
  final DateTime  createdAt;
  final DateTime? updatedAt;
  final int       viewCount;

  const KanbanCard({
    required this.id,
    required this.quoteNumberDisplay,
    required this.customerName,
    required this.status,
    required this.isApproved,
    required this.currency,
    required this.grandTotal,
    required this.createdAt,
    this.updatedAt,
    required this.viewCount,
  });

  factory KanbanCard.fromJson(Map<String, dynamic> json) => KanbanCard(
        id:                 json['id'] as String,
        quoteNumberDisplay: json['quoteNumberDisplay'] as String,
        customerName:       json['customerName'] as String,
        status:             json['status'] as int,
        isApproved:         json['isApproved'] as bool,
        currency:           json['currency'] as String,
        grandTotal:         (json['grandTotal'] as num).toDouble(),
        createdAt:          DateTime.parse(json['createdAt'] as String),
        updatedAt:          json['updatedAt'] != null
                                ? DateTime.parse(json['updatedAt'] as String)
                                : null,
        viewCount:          json['viewCount'] as int,
      );

  KanbanCard copyWith({int? status, bool? isApproved}) => KanbanCard(
        id:                 id,
        quoteNumberDisplay: quoteNumberDisplay,
        customerName:       customerName,
        status:             status ?? this.status,
        isApproved:         isApproved ?? this.isApproved,
        currency:           currency,
        grandTotal:         grandTotal,
        createdAt:          createdAt,
        updatedAt:          updatedAt,
        viewCount:          viewCount,
      );
}
