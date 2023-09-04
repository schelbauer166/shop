import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.PRODUCT_FORM_PAGE, arguments: product);
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.deepPurple,
              ),
            ),
            Dismissible(
              key: ValueKey(product),
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Excluir Produto'),
                      content: const Text('Tem certeza?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            Provider.of<ProductList>(
                              context,
                              listen: false,
                            ).removeProduct(product);
                          },
                          child: const Text('Sim'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            return;
                          },
                          child: const Text('Nao'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.deepOrange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
