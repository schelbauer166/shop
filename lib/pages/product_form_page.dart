import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';

class ProductFormPage extends StatefulWidget {
  ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _focusPrice = FocusNode();
  final _focusUrlDaImagem = FocusNode();
  final _focusDescription = FocusNode();

  final _imageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formDate = Map<String, Object>();
  bool _isloading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arg = ModalRoute.of(context)?.settings.arguments;

    if (arg != null) {
      final product = arg as Product;
      _formDate['id'] = product.id;
      _formDate['title'] = product.title;
      _formDate['price'] = product.price;
      _formDate['description'] = product.description;
      _formDate['imageUrl'] = product.imageUrl;

      _imageController.text = product.imageUrl;
    }
  }

  @override
  void initState() {
    super.initState();
    _focusUrlDaImagem.addListener(_updateUrl);
  }

  @override
  void dispose() {
    super.dispose();
    _focusDescription.dispose();
    _focusPrice.dispose();
    _focusUrlDaImagem.removeListener(_updateUrl);
    _focusUrlDaImagem.dispose();
  }

  Future<void> _onSubmited() async {
    bool isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() => _isloading = true);

    try {
      await Provider.of<ProductList>(
        context,
        listen: false,
      ).saveProduct(_formDate);
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Ocorreu um erro'),
                content: const Text('Ocorreu um erro ao salvar o produto'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Ok'),
                  ),
                ],
              ));
    } finally {
      setState(() => _isloading = false);
    }
  }

  void _updateUrl() {
    setState(() {});
  }

  bool isUrlValid(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endWith = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');
    return isValidUrl && endWith;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Produto'),
        actions: [
          IconButton(
            onPressed: _onSubmited,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formDate['title']?.toString(),
                      decoration: const InputDecoration(
                        label: Text('Nome'),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_focusPrice),
                      onSaved: (title) => _formDate['title'] = title ?? '',
                      validator: (_title) {
                        final name = _title ?? '';

                        if (name.trim().isEmpty) {
                          return 'Nome nao pode ser vazio.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formDate['price']?.toString(),
                      decoration: const InputDecoration(
                        label: Text('Preco'),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      focusNode: _focusPrice,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_focusDescription),
                      onSaved: (price) =>
                          _formDate['price'] = double.parse(price ?? ''),
                      validator: (_price) {
                        final priceString = _price ?? '';
                        final price = double.parse(priceString);
                        if (price <= 0) {
                          return 'Informe um preco valido';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formDate['description']?.toString(),
                      decoration: const InputDecoration(
                        label: Text('Descricao'),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      focusNode: _focusDescription,
                      onSaved: (description) =>
                          _formDate['description'] = description ?? '',
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              label: Text('Url da imagem'),
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _focusUrlDaImagem,
                            controller: _imageController,
                            onSaved: (imageUrl) =>
                                _formDate['imageUrl'] = imageUrl ?? '',
                            validator: (_imageUrl) {
                              final imageUrl = _imageUrl ?? '';
                              if (!isUrlValid(imageUrl)) {
                                return "Informe uma Url valida";
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                            left: 10,
                          ),
                          alignment: Alignment.center,
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageController.text.isEmpty
                              ? const Text('Informe a Url')
                              : FittedBox(
                                  fit: BoxFit.cover,
                                  child: Image.network(_imageController.text),
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
