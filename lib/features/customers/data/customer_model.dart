import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

@freezed
class Customer with _$Customer {
  const factory Customer({
    required String  id,
    required String  name,
    required String  phone,
    required String  email,
    required String  address,
    String?          taxNumber,
    String?          taxOffice,
    String?          notes,
    required bool    isActive,
    required DateTime createdAt,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}
