import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'food_item.freezed.dart';
part 'food_item.g.dart';

@freezed
@Collection(ignore: {'copyWith'})
class FoodItem with _$FoodItem {
  const FoodItem._();
  const factory FoodItem({
    required int id,
    required String name,
    required String imageUrl,
    required double price,
    required String restaurantChain,
  }) = _FoodItem;
  @override
  Id get id => id;
  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);
}
