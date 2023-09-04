import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/order_page.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/product_form_page.dart';
import 'package:shop/pages/product_page.dart';
import 'package:shop/pages/products_overview_page.dart';
import 'package:shop/utils/app_routes.dart';

import 'models/cart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderList(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple, secondary: Colors.deepOrange),
          fontFamily: 'Lato',
        ),
        routes: {
          AppRoutes.HOME: (context) => const ProductsOverviewPage(),
          AppRoutes.ORDER_PAGE: (context) => const OrderPage(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetailPage(),
          AppRoutes.CART_PAGE: (ctx) => const CartPage(),
          AppRoutes.PRODUCT_PAGE: (context) => const ProductPage(),
          AppRoutes.PRODUCT_FORM_PAGE: (context) => ProductFormPage(),
        },
      ),
    );
  }
}
