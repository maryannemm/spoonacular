import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:spoonacular/db/food_items_db.dart';
import 'package:spoonacular/model/food_item.dart';

class ApiService {
  final Dio _dio = Dio();
  final FoodItemsIsar _foodItemsIsar;
  bool _stopRequests = false;

  ApiService(this._foodItemsIsar);

  Future<void> fetchAndStoreAllFoodItems(String query) async {
    if (_stopRequests) {
      debugPrint('Requests have been stopped due to a previous 402 response.');
      return;
    }

    const int itemsPerPage = 100;
    int totalItems = 0;
    int offset = 0;

    await _foodItemsIsar.openIsar();

    do {
      try {
        final response = await _dio.get(
          'https://api.spoonacular.com/food/menuItems/search',
          queryParameters: {
            'query': query,
            'number': itemsPerPage,
            'offset': offset,
            'apiKey': '9edd626a36254739af07fd646f7fa213',
          },
        );

        if (response.statusCode == 200) {
          final List data = response.data['menuItems'];
          totalItems = response.data['totalMenuItems'];

          for (var item in data) {
            await fetchAndStoreFoodItemDetails(item['id']);
          }

          offset += itemsPerPage;
        } else if (response.statusCode == 402) {
          debugPrint('Received status code 402: Payment Required');
          _stopRequests = true;
          break;
        }
      } on DioException catch (e) {
        debugPrint('Error fetching food items: $e');
        break;
      }
    } while (offset < totalItems);
  }

  Future<void> fetchAndStoreFoodItemDetails(int itemId) async {
    if (_stopRequests) {
      debugPrint('Requests have been stopped due to a previous 402 response.');
      return;
    }

    final existingItem =
        await _foodItemsIsar.foodItems.where().idEqualTo(itemId).findFirst();

    if (existingItem != null) {
      debugPrint('Item with id $itemId already exists in the database');
      return;
    }

    await _foodItemsIsar.foodItems.isar.writeTxn(() async {
      final response = await _dio.get(
        'https://api.spoonacular.com/food/menuItems/$itemId',
        queryParameters: {
          'apiKey': '',
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
          price: itemData['price'] ?? 50.0,
        );

        // write
        await _foodItemsIsar.foodItems.put(foodItem);
      } else {
        debugPrint('Failed to fetch item details for id $itemId');
      }
    });
  }

  Future<List<FoodItem>> getFoodItems() async {
    await _foodItemsIsar.openIsar();
    return await _foodItemsIsar.foodItems.where().findAll();
  }
}
