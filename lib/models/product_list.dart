import 'dart:convert';

import 'dart:math';

import 'package:flutter/material.dart';

import 'package:shop/models/product.dart';
import 'package:http/http.dart' as http;

class ProductList extends ChangeNotifier {
  final List<Product> _items = [];
  final _Url = 'https://shop-f3lipe-default-rtdb.firebaseio.com/products.json';

  List<Product> get items {
    if (_showFavoriteOnly) {
      return _items.where((element) => element.isFavorite).toList();
    }
    return [..._items];
  }

  bool _showFavoriteOnly = false;

  int get itemCount {
    return _items.length;
  }

  void showFavoriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      title: data['title'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> loadProducts() async {
    final response = await http.get(Uri.parse(_Url));
    if (response.body == 'null') return;
    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((productId, productData) {
      _items.add(
        Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite'],
        ),
      );
    });
  }

  Future<void> updateProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse(_Url),
      body: jsonEncode(
        {
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(
      Product(
        id: id,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
      ),
    );
    notifyListeners();
  }

  void removeProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();
    }
  }
}
