class AiQuoteItemSuggestion {
  const AiQuoteItemSuggestion({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    this.note,
  });

  final String productId;
  final String productName;
  final double quantity;
  final String unit;
  final double unitPrice;
  final String? note;

  factory AiQuoteItemSuggestion.fromJson(Map<String, dynamic> json) =>
      AiQuoteItemSuggestion(
        productId  : json['productId'] as String,
        productName: json['productName'] as String,
        quantity   : (json['quantity'] as num).toDouble(),
        unit       : json['unit'] as String,
        unitPrice  : (json['unitPrice'] as num).toDouble(),
        note       : json['note'] as String?,
      );
}
