import 'package:isar/isar.dart';
import 'package:spoonacular/model/food_item.dart';
import 'package:path_provider/path_provider.dart';

class FoodItemsIsar {
  @ignore
  late IsarCollection<FoodItem> foodItems;

  Future<void> openIsar() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final isar = await Isar.open([FoodItemSchema], directory: path);
    foodItems = isar.foodItems;
  }

  Future<List<FoodItem>> getFoodItems() async {
    await openIsar();
    return await foodItems.where().findAll();
  }
}
