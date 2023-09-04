import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

import '../components/badged.dart';
import '../components/product_grid.dart';
import '../models/cart.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({super.key});

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(context, listen: false)
        .loadProducts()
        .then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Loja'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.Favorite,
                child: Text('Somente favoritos'),
              ),
              const PopupMenuItem(
                value: FilterOptions.All,
                child: Text('Todos'),
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Favorite) {
                provider.showFavoriteOnly();
              } else {
                provider.showAll();
              }
            },
          ),
          Consumer<Cart>(
            builder: (context, cart, child) => Badgedd(
              value: cart.itemsCounts.toString(),
              child: IconButton(
                padding: const EdgeInsets.only(top: 12, right: 10),
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.CART_PAGE),
                icon: const Icon(
                  Icons.shopping_bag,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const ProductGrid(),
      drawer: const AppDrawer(),
    );
  }
}
