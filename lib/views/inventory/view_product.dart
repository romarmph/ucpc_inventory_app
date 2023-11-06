import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

class ProductView extends ConsumerStatefulWidget {
  const ProductView({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductViewState();
}

class _ProductViewState extends ConsumerState<ProductView> {
  bool _isReadOnly = true;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _barcodeController = TextEditingController();
  late bool _isPopular;
  late bool _isHidden;
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
      id: widget.product.id,
      name: _nameController.text,
      description: _descriptionController.text,
      price: price,
      quantity: quantity,
      createdBy: widget.product.createdBy,
      createdAt: widget.product.createdAt,
      imageUrls: [],
      isPopular: _isPopular,
      isHidden: _isHidden,
      barcode: _barcodeController.text,
      updatedAt: Timestamp.now(),
      updatedBy: ref.watch(authProvider).currentUser.uid,
    );

    try {
      _showLoadingDialog();
      await ProductDatabase.instance.updateProduct(product);
      await _uploadIMages(product.id!);
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
      if (image.contains('firebase')) {
        continue;
      }
      final url = await storage.uploadImage(File(image), productId);
      await ProductDatabase.instance.addImageUrl(url, productId);
    }
  }

  @override
  void initState() {
    _nameController.text = widget.product.name;
    _descriptionController.text = widget.product.description;
    _priceController.text = widget.product.price.toString();
    _quantityController.text = widget.product.quantity.toString();
    _barcodeController.text = widget.product.barcode;
    _imageList.addAll(widget.product.imageUrls);
    _isPopular = widget.product.isPopular;
    _isHidden = widget.product.isHidden;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isReadOnly) {
          return true;
        }

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

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isReadOnly ? 'View Product' : 'Edit Product'),
          actions: [
            Visibility(
              visible: !_isReadOnly,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                ),
                onPressed: () {
                  setState(() {
                    _isReadOnly = true;
                  });
                },
                label: const Text('Cancel'),
                icon: const Icon(Icons.cancel_rounded),
              ),
            ),
            Visibility(
              visible: _isReadOnly,
              child: PopupMenuButton(
                itemBuilder: (context) {
                  return const [
                    PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        title: Text('Edit'),
                        leading: Icon(Icons.edit_rounded),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        title: Text('Delete'),
                        leading: Icon(Icons.delete_rounded),
                      ),
                    ),
                  ];
                },
                onSelected: (value) {
                  if (value == 'edit') {
                    setState(() {
                      _isReadOnly = false;
                    });
                  } else {
                    _showDeleteConfirmation();
                  }
                },
              ),
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
                    readOnly: _isReadOnly,
                    controller: _barcodeController,
                    decoration: InputDecoration(
                      labelText: 'Barcode',
                      suffixIcon: IconButton(
                        onPressed: _isReadOnly
                            ? null
                            : () async {
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
                    readOnly: _isReadOnly,
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    validator: (value) =>
                        ProductFormValidator.validateName(value!),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    readOnly: _isReadOnly,
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    validator: (value) =>
                        ProductFormValidator.validateDescription(value!),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    readOnly: _isReadOnly,
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
                    readOnly: _isReadOnly,
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
                        value: _isPopular,
                        onChanged: _isReadOnly
                            ? null
                            : (value) {
                                setState(() {
                                  _isPopular = value;
                                });
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
                        value: _isHidden,
                        onChanged: _isReadOnly
                            ? null
                            : (value) {
                                setState(() {
                                  _isHidden = value;
                                });
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
                      Visibility(
                        visible: !_isReadOnly,
                        child: TextButton.icon(
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
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
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
                            return Visibility(
                              visible: !_isReadOnly,
                              child: ImagesEmptyStateAddButton(
                                constraints: constraints,
                                onTap: () async {
                                  final imagePicker =
                                      ImagePickerService.instance;

                                  final image = await imagePicker.pickImage();

                                  if (image == null) {
                                    return;
                                  }

                                  setState(() {
                                    _imageList.add(image.path);
                                  });
                                },
                              ),
                            );
                          }

                          final String url = _imageList[index];

                          if (url.contains('firebase')) {
                            return ProductImageCard(
                              isReadOnly: _isReadOnly,
                              isNetworkImage: true,
                              url: url,
                              onPressed: () {
                                _showImageRemoveConfirmationDialog(
                                  url,
                                );
                              },
                            );
                          }

                          return ProductImageCard(
                            isReadOnly: _isReadOnly,
                            isNetworkImage: false,
                            url: url,
                            onPressed: () {
                              _showImageRemoveConfirmationDialog(
                                url,
                              );
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
        floatingActionButton: Visibility(
          visible: !_isReadOnly,
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.all(12),
            ),
            onPressed: _addProduct,
            label: const Text('Save'),
            icon: const Icon(Icons.save_rounded),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation() async {
    final result = await QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Are you sure?',
      text: 'Do you want to delete this product?',
      onConfirmBtnTap: () async {
        Navigator.of(context).pop(true);
      },
    );

    if (result == null) {
      return;
    }

    await ProductDatabase.instance.deleteProduct(widget.product.id!);
    _pop();
  }

  void _showImageRemoveConfirmationDialog(String url) async {
    await QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      title: 'Are you sure?',
      text: 'Do you want to remove this image?',
      onConfirmBtnTap: () async {
        setState(() {
          _imageList.remove(url);
        });
        if (url.contains('firebase')) {
          await StorageService.instance.deleteImage(url);
        }
        _pop();
      },
    );
  }
}
