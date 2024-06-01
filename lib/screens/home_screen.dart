import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:spoonacular/store/food_store.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final foodStore = Provider.of<FoodStore>(context);

    // Call fetchFoodItems method when the screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await foodStore.fetchFoodItems();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch food items: $e')),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Food Ordering App'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (foodStore.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (foodStore.errorMessage != null) {
            return Center(child: Text(foodStore.errorMessage!));
          } else if (foodStore.foodItems.isEmpty) {
            return Center(child: Text('No food items available'));
          } else {
            return ListView.builder(
              itemCount: foodStore.foodItems.length,
              itemBuilder: (context, index) {
                final foodItem = foodStore.foodItems[index];
                return ListTile(
                  leading: Image.network(foodItem.imageUrl),
                  title: Text(foodItem.name),
                  subtitle: Text(
                      '${foodItem.restaurantChain}\n\$${foodItem.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      foodStore.addToCart(foodItem);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
