import 'package:isar/isar.dart';
import 'package:spoonacular/model/food_item.dart';
import 'package:path_provider/path_provider.dart';

class FoodItemsIsar {
  static final FoodItemsIsar _instance = FoodItemsIsar._internal();
  late Isar isar;
  late IsarCollection<FoodItem> foodItems;

  factory FoodItemsIsar() {
    return _instance;
  }

  FoodItemsIsar._internal();

  Future<void> openIsar() async {
    if (!Isar.instanceNames.contains('food_items')) {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      isar = await Isar.open(
        [FoodItemSchema],
        directory: path,
        name: 'food_items',
      );
      foodItems = isar.foodItems;
    } else {
      isar = Isar.getInstance('food_items')!;
      foodItems = isar.foodItems;
    }
  }

  Future<void> closeIsar() async {
    await isar.close();
  }

  Future<List<FoodItem>> getFoodItems() async {
    await openIsar();
    return await foodItems.where().findAll();
  }

  Future<void> updateAddToCart(FoodItem foodItem) async {
    await openIsar();
    var existingFoodItem =
        await foodItems.where().idEqualTo(foodItem.id).findFirst();

    existingFoodItem = existingFoodItem!.copyWith(isInCart: true);
    await isar.writeTxn(() async {
      await foodItems.put(existingFoodItem!);
    });
    isar.close();
  }

  Future<void> updateRemoveFromCart(FoodItem foodItem) async {
    await openIsar();
    var existingFoodItem =
        await foodItems.where().idEqualTo(foodItem.id).findFirst();

    if (existingFoodItem != null) {
      existingFoodItem = existingFoodItem.copyWith(isInCart: false);
      await isar.writeTxn(() async {
        await foodItems.put(existingFoodItem!);
      });
    }
    closeIsar();
  }

  Future<void> clearCartList() async {
    await openIsar();
    final itemsInCart =
        await foodItems.where().filter().isInCartEqualTo(true).findAll();

    for (var item in itemsInCart) {
      item = item.copyWith(isInCart: false);
    }
    closeIsar();
  }

  Future<void> updateCartItem(int itemId, int quantity) async {
    final Item = await foodItems
        .where()
        .idEqualTo(itemId)
        .isInCartProperty()
        .findFirst();
    foodItems = quantity as IsarCollection<FoodItem>;
    await foodItems.put(Item as FoodItem);
  }
}
