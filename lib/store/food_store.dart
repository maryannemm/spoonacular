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
    final existingItemIndex =
        cartItems.indexWhere((item) => item.id == foodItem.id);

    if (existingItemIndex != -1) {
      final existingItem = cartItems[existingItemIndex];
      final updatedItem = existingItem.copyWith(
          quantityInCart: existingItem.quantityInCart + 1);
      cartItems[existingItemIndex] = updatedItem;
    } else {
      cartItems.add(foodItem.copyWith(quantityInCart: 1));
    }
  }

  @action
  void removeFromCart(FoodItem foodItem) {
    final existingItemIndex =
        cartItems.indexWhere((item) => item.id == foodItem.id);

    if (existingItemIndex != -1) {
      final existingItem = cartItems[existingItemIndex];
      if (existingItem.quantityInCart > 1) {
        final updatedItem = existingItem.copyWith(
            quantityInCart: existingItem.quantityInCart - 1);
        cartItems[existingItemIndex] = updatedItem;
      } else {
        cartItems.removeAt(existingItemIndex);
      }
    }
  }

  @action
  void checkout() {
    cartItems.clear();
  }
}
