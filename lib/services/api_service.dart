import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:spoonacular/db/food_items_db.dart';
import 'package:spoonacular/model/food_item.dart';

class ApiService {
  final Dio _dio = Dio();
  final FoodItemsIsar foodItemsIsar;

  ApiService(this.foodItemsIsar);

  Future<void> fetchAndStoreAllFoodItems(String query) async {
    const int itemsPerPage = 100;
    int offset = 0;

    await foodItemsIsar.openIsar();

    while (true) {
      final response = await _dio.get(
        'https://api.spoonacular.com/food/menuItems/search',
        queryParameters: {
          'query': query,
          'number': itemsPerPage,
          'offset': offset,
          'apiKey': '9edd626a36254739af07fd646f7fa213',
        },
      );

      final List data = response.data['menuItems'];
      final totalItems = response.data['totalMenuItems'];

      for (var item in data) {
        await fetchAndStoreFoodItemDetails(item['id']);
      }

      offset += itemsPerPage;

      if (offset >= totalItems) break;
    }
  }

  Future<void> fetchAndStoreFoodItemDetails(int itemId) async {
    final existingItem =
        await foodItemsIsar.foodItems.where().idEqualTo(itemId).findFirst();

    if (existingItem != null) {
      return;
    }

    final response = await _dio.get(
      'https://api.spoonacular.com/food/menuItems/$itemId',
      queryParameters: {
        'apiKey': '9edd626a36254739af07fd646f7fa213',
      },
    );

    if (response.statusCode == 200) {
      final itemData = response.data;

      final foodItem = FoodItem(
        id: itemData['id'],
        name: itemData['title'],
        restaurantChain: itemData['restaurantChain'],
        imageUrl:
            'https://img.spoonacular.com/menu-items/${itemData['id']}-312x231.${itemData['imageType']}',
        price: itemData['price'] ?? 50.00,
        isInCart: false,
        quantityInCart: 0,
      );

      // Call a separate function to handle database write operation
      await _saveFoodItemToDatabase(foodItem);
    }
  }

  Future<void> _saveFoodItemToDatabase(FoodItem foodItem) async {
    await foodItemsIsar.isar.writeTxn(() async {
      await foodItemsIsar.foodItems.put(foodItem);
    });
  }
}
