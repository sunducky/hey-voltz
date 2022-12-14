import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class CartItem {
  int id;
  int quantity;
  int stock;
  String name;
  String image;
  double price;

  CartItem({
    required this.id,
    required this.quantity,
    required this.name,
    required this.image,
    required this.price,
    required this.stock,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemToJson(this);
}
