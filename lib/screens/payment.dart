import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:spoonacular/store/food_store.dart';

class PaypalCheckoutService {
  static void startCheckout(BuildContext context, FoodStore foodStore) {
    double totalAmount = foodStore.cartItems
        .map((foodItem) => foodItem.price * foodItem.quantityInCart)
        .fold(0, (prev, amount) => prev + amount);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckout(
          sandboxMode: true,
          clientId:
              "AZYGs3XJiawzeo3g-KV1ngZ6a3mwBP62z97nAGCGqVmKpy63_ELw-UxVv8YBQazDVqpzSN6klGIi79ll",
          secretKey:
              "EAXV-g6oMomik25Jwfq1PdLdXg66u-aI8ih8i-kspc6OJ8Z3ruLxbrU2z77o36AQyb5tuByLnBFNptz6",
          returnURL: "success.snippetcoder.com",
          cancelURL: "cancel.snippetcoder.com",
          transactions: [
            {
              "amount": {
                "total": totalAmount.toStringAsFixed(2),
                "currency": "USD",
                "details": {
                  "subtotal": totalAmount.toStringAsFixed(2),
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description": "The payment transaction description.",
              "item_list": {
                "items": foodStore.cartItems.map((item) {
                  return {
                    "name": item.name,
                    "quantity": item.quantityInCart,
                    "price": item.price.toStringAsFixed(2),
                    "currency": "USD"
                  };
                }).toList()
              }
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            Navigator.pushNamed(context, '/success');
          },
          onError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('An error occured ${error}')));
            Navigator.pop(context);
          },
          onCancel: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
      ),
    );
  }
}
