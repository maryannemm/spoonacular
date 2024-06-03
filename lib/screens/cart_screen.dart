import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:spoonacular/screens/payment.dart';
import 'package:spoonacular/store/food_store.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final foodStore = Provider.of<FoodStore>(context);

    double totalAmount = foodStore.cartItems
        .map((foodItem) => foodItem.price * foodItem.quantityInCart)
        .fold(0, (prev, amount) => prev + amount);

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
                  leading: Image.network(
                    foodItem.imageUrl,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/burger.jpg',
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      );
                    },
                  ),
                  title: Text(foodItem.name),
                  subtitle: Text(
                    '${foodItem.restaurantChain}\n\$${foodItem.price.toStringAsFixed(2)} x ${foodItem.quantityInCart}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_shopping_cart),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${foodItem.name} removed from cart.'),
                        ),
                      );
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total: \$${totalAmount.toStringAsFixed(2)}'),
            ElevatedButton(
              onPressed: () {
                foodStore.checkout();
                PaypalCheckoutService.startCheckout(context, foodStore);
              },
              child: Text('Paypal Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
