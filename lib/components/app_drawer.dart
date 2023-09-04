import 'package:flutter/material.dart';
import 'package:shop/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Bem vindo Usuario!'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(
              Icons.shop,
            ),
            title: const Text("Loja"),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(AppRoutes.HOME),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.money,
            ),
            title: const Text("Pedidos"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(AppRoutes.ORDER_PAGE),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.edit,
            ),
            title: const Text("Gerenciar Produtos"),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(AppRoutes.PRODUCT_PAGE),
          ),
        ],
      ),
    );
  }
}
