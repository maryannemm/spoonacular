// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FoodStore on _FoodStore, Store {
  late final _$foodItemsAtom =
      Atom(name: '_FoodStore.foodItems', context: context);

  @override
  ObservableList<FoodItem> get foodItems {
    _$foodItemsAtom.reportRead();
    return super.foodItems;
  }

  @override
  set foodItems(ObservableList<FoodItem> value) {
    _$foodItemsAtom.reportWrite(value, super.foodItems, () {
      super.foodItems = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_FoodStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_FoodStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$cartItemsAtom =
      Atom(name: '_FoodStore.cartItems', context: context);

  @override
  ObservableList<FoodItem> get cartItems {
    _$cartItemsAtom.reportRead();
    return super.cartItems;
  }

  @override
  set cartItems(ObservableList<FoodItem> value) {
    _$cartItemsAtom.reportWrite(value, super.cartItems, () {
      super.cartItems = value;
    });
  }

  late final _$fetchFoodItemsAsyncAction =
      AsyncAction('_FoodStore.fetchFoodItems', context: context);

  @override
  Future<void> fetchFoodItems() {
    return _$fetchFoodItemsAsyncAction.run(() => super.fetchFoodItems());
  }

  late final _$checkoutAsyncAction =
      AsyncAction('_FoodStore.checkout', context: context);

  @override
  Future<void> checkout() {
    return _$checkoutAsyncAction.run(() => checkout());
  }

  late final _$_FoodStoreActionController =
      ActionController(name: '_FoodStore', context: context);

  @override
  void addToCart(FoodItem foodItem) {
    final _$actionInfo =
        _$_FoodStoreActionController.startAction(name: '_FoodStore.addToCart');
    try {
      return super.addToCart(foodItem);
    } finally {
      _$_FoodStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeFromCart(FoodItem foodItem) {
    final _$actionInfo = _$_FoodStoreActionController.startAction(
        name: '_FoodStore.removeFromCart');
    try {
      return super.removeFromCart(foodItem);
    } finally {
      _$_FoodStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
foodItems: ${foodItems},
isLoading: ${isLoading},
errorMessage: ${errorMessage},
cartItems: ${cartItems}
    ''';
  }
}
