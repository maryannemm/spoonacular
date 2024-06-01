import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:spoonacular/store/food_store.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final foodStore = Provider.of<FoodStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Observer(
        builder: (_) {
          if (foodStore.cartItems.isEmpty) {
            return Center(child: Text('Your cart is empty'));
          } else {
            return ListView.builder(
              itemCount: foodStore.cartItems.length,
              itemBuilder: (context, index) {
                final foodItem = foodStore.cartItems[index];
                return ListTile(
                  leading: Image.network(foodItem.imageUrl),
                  title: Text(foodItem.name),
                  subtitle: Text(
                      '${foodItem.restaurantChain}\n\$${foodItem.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_shopping_cart),
                    onPressed: () {
                      foodStore.removeFromCart(foodItem);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () async {
            await foodStore.checkout();
            Navigator.pushNamed(context, '/success');
          },
          child: Text('Checkout'),
        ),
      ),
    );
  }
}
