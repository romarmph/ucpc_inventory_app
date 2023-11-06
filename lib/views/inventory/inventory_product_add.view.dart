import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

class ProductAddView extends ConsumerStatefulWidget {
  const ProductAddView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductAddViewState();
}

class _ProductAddViewState extends ConsumerState<ProductAddView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _barcodeController = TextEditingController();
  final List _imageList = [];

  void _addProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final double price =
        _priceController.text.isEmpty ? 0 : double.parse(_priceController.text);
    final int quantity = _quantityController.text.isEmpty
        ? 0
        : int.parse(_quantityController.text);

    final product = Product(
      name: _nameController.text,
      description: _descriptionController.text,
      price: price,
      quantity: quantity,
      createdBy: ref.read(authProvider).currentUser.uid,
      createdAt: Timestamp.now(),
      imageUrls: [],
      isPopular: ref.watch(markAsPopularStateProvider),
      isHidden: ref.watch(markAsHiddenStateProvider),
      barcode: _barcodeController.text,
    );

    try {
      String productId = '';
      _showLoadingDialog();
      await ProductDatabase.instance.addProduct(product).then((docId) {
        productId = docId;
      });
      await _uploadIMages(productId);
      _pop();
    } on Exception {
      _showErrorDialog('Failed to add product. Try again');
      return;
    }
    _pop();
  }

  void _showLoadingDialog() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Saving Product',
      barrierDismissible: false,
    );
  }

  void _showErrorDialog(String text) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: 'Error',
      text: text,
    );
  }

  void _pop() {
    Navigator.pop(context);
  }

  Future<void> _uploadIMages(String productId) async {
    final storage = StorageService.instance;

    for (final image in _imageList) {
      final url = await storage.uploadImage(File(image), productId);
      await ProductDatabase.instance.addImageUrl(url, productId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final result = await QuickAlert.show(
          context: context,
          type: QuickAlertType.confirm,
          title: 'Are you sure?',
          text: 'Do you want to discard this product?',
          onConfirmBtnTap: () => Navigator.pop(context, true),
        );

        if (result == null) {
          return false;
        }

        ref.invalidate(markAsHiddenStateProvider);
        ref.invalidate(markAsPopularStateProvider);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Product'),
          actions: [
            FilledButton.icon(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(12),
              ),
              onPressed: _addProduct,
              label: const Text('Save'),
              icon: const Icon(Icons.save_rounded),
            ),
            const SizedBox(width: 12),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _barcodeController,
                    decoration: InputDecoration(
                      labelText: 'Barcode',
                      suffixIcon: IconButton(
                        onPressed: () async {
                          final barcode = await Navigator.pushNamed(
                            context,
                            Routes.barcodeScanner,
                          );

                          if (barcode == null) {
                            return;
                          }

                          _barcodeController.text = barcode.toString();
                        },
                        icon: const Icon(Icons.qr_code_scanner_rounded),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    validator: (value) =>
                        ProductFormValidator.validateName(value!),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    validator: (value) =>
                        ProductFormValidator.validateDescription(value!),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price',
                      hintText: '0',
                    ),
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    validator: (value) =>
                        ProductFormValidator.validatePrice(value!),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      hintText: '0',
                    ),
                    textAlign: TextAlign.right,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        'Mark as Popular',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Switch(
                        value: ref.watch(markAsPopularStateProvider),
                        onChanged: (value) {
                          ref
                              .read(markAsPopularStateProvider.notifier)
                              .update((state) => value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        'Mark as Hidden',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      Switch(
                        value: ref.watch(markAsHiddenStateProvider),
                        onChanged: (value) {
                          ref
                              .read(markAsHiddenStateProvider.notifier)
                              .update((state) => value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        'Images',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: () async {
                          final imagePicker = ImagePickerService.instance;

                          final image = await imagePicker.pickImage();

                          if (image == null) {
                            return;
                          }

                          setState(() {
                            _imageList.add(image.path);
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Image'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _imageList.isEmpty ? 1 : _imageList.length,
                        itemBuilder: (context, index) {
                          if (_imageList.isEmpty) {
                            return ImagesEmptyStateAddButton(
                              constraints: constraints,
                              onTap: () async {
                                final imagePicker = ImagePickerService.instance;

                                final image = await imagePicker.pickImage();

                                if (image == null) {
                                  return;
                                }

                                setState(() {
                                  _imageList.add(image.path);
                                });
                              },
                            );
                          }
                          return ProductImageCard(
                            url: _imageList[index],
                            onPressed: () {
                              setState(() {
                                _imageList.removeAt(index);
                              });
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(width: 12);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
