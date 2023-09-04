import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart_item.dart';

import '../models/cart.dart';

// ignore: must_be_immutable
class CartItemWidget extends StatelessWidget {
  CartItem itemCart;
  CartItemWidget(this.itemCart, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(itemCart.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        color: Colors.red,
        child: const Padding(
          padding: EdgeInsets.only(right: 15),
          child: Icon(
            Icons.delete,
          ),
        ),
      ),
      confirmDismiss: (_) {
        return showDialog<bool>(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Tem Certeza?'),
              content: const Text('Quer remover o item?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: const Text('Sim'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: const Text('Nao'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (_) {
        Provider.of<Cart>(
          context,
          listen: false,
        ).removeItem(itemCart.productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text(
                    itemCart.price.toString(),
                  ),
                ),
              ),
            ),
            title: Text(itemCart.name),
            subtitle: Text("Total: ${itemCart.quantity * itemCart.price}"),
            trailing: Text("${itemCart.quantity}x"),
          ),
        ),
      ),
    );
  }
}
