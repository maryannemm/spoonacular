import 'package:mobx/mobx.dart';
import 'package:spoonacular/db/food_items_db.dart';
import 'package:spoonacular/model/food_item.dart';

part 'food_store.g.dart';

class FoodStore = _FoodStore with _$FoodStore;

abstract class _FoodStore with Store {
  final FoodItemsIsar foodItemsIsar;

  _FoodStore(this.foodItemsIsar);

  @observable
  ObservableList<FoodItem> foodItems = ObservableList<FoodItem>();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> fetchFoodItems() async {
    try {
      isLoading = true;
      errorMessage = null;
      foodItems.clear();
      final items = await foodItemsIsar.getFoodItems();
      foodItems.addAll(items);
    } catch (e) {
      print('Error fetching food items from Isar database: $e');
      errorMessage = 'Failed to fetch food items: $e';
    } finally {
      isLoading = false;
    }
  }

  @observable
  ObservableList<FoodItem> cartItems = ObservableList<FoodItem>();

  @action
  void addToCart(FoodItem foodItem) {
    cartItems.add(foodItem);
  }

  @action
  void removeFromCart(FoodItem foodItem) {
    cartItems.remove(foodItem);
  }

  @action
  Future<void> checkout() async {
    cartItems.clear();
  }
}
