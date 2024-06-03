import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:spoonacular/db/food_items_db.dart';
import 'package:spoonacular/services/api_service.dart';
import 'package:spoonacular/store/food_store.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final foodItemsIsar = FoodItemsIsar();
    final ApiService apiService = ApiService(foodItemsIsar);
    apiService.fetchAndStoreAllFoodItems('burger');
  }

  @override
  Widget build(BuildContext context) {
    final foodStore = Provider.of<FoodStore>(context);
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
        title: Text('Burger Ordering App'),
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
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 0.7,
              ),
              itemCount: foodStore.foodItems.length,
              itemBuilder: (context, index) {
                final foodItem = foodStore.foodItems[index];
                return Card(
                  elevation: 2.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          foodItem.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/burger.jpg',
                              fit: BoxFit.cover,
                              width: double.infinity,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          foodItem.name,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(foodItem.restaurantChain),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('\$${foodItem.price.toStringAsFixed(2)}'),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('${foodItem.name} added to cart.'),
                              ),
                            );
                            foodStore.addToCart(foodItem);
                          },
                        ),
                      ),
                    ],
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
