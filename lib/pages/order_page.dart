import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order_widget.dart';
import 'package:shop/models/order_list.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderList order = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: order.itemsCount,
        itemBuilder: (context, index) => OrderWidget(
          order: order.items[index],
        ),
      ),
    );
  }
}
