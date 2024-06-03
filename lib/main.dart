import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spoonacular/db/food_items_db.dart';
import 'package:spoonacular/screens/cart_screen.dart';
import 'package:spoonacular/screens/home_screen.dart';
import 'package:spoonacular/screens/success_screen.dart';
import 'package:spoonacular/services/api_service.dart';
import 'package:spoonacular/store/food_store.dart';

import 'db/auth_db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthDB.init();

  final foodItemsIsar = FoodItemsIsar();
  // ignore: unused_local_variable
  final apiService = ApiService(foodItemsIsar);
  final foodStore = FoodStore(foodItemsIsar);

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => foodStore),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Ordering App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(color: Colors.deepPurple[200]),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/cart': (context) => CartScreen(),
        '/success': (context) => SuccessScreen(),
      },
    );
  }
}
