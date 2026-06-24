import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String  id,
    String?          categoryId,
    String?          categoryName,
    required String  name,
    required String  unit,
    required double  purchasePrice,
    required double  salePrice,
    String?          notes,
    String?          photoUrl,
    required bool    isActive,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
