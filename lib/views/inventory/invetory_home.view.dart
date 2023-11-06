import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

class InventoryHomeView extends ConsumerStatefulWidget {
  const InventoryHomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InventoryHomeViewState();
}

class _InventoryHomeViewState extends ConsumerState<InventoryHomeView> {
  List<Product> _selectedProducts = [];
  bool _isSelectMode = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _selectedProducts = [];
        _isSelectMode = false;
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inventory'),
          actions: [
            _isSelectMode
                ? SelectedProductCounter(
                    selectedCount: _selectedProducts.length,
                    onPressed: () {
                      setState(() {
                        _selectedProducts = [];
                        _isSelectMode = false;
                      });
                    },
                  )
                : const SizedBox(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Products',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.addProduct);
                      },
                      child: const Text('Add Product'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        if (_isSelectMode) {
                          setState(() {
                            _isSelectMode = false;
                            _selectedProducts = [];
                          });
                        } else {
                          setState(() {
                            _isSelectMode = true;
                            _selectedProducts = [];
                          });
                        }
                      },
                      child: Text(_isSelectMode ? 'Cancel' : 'Select Products'),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: _isSelectMode && _selectedProducts.isNotEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.greenAccent[700],
                      ),
                      onPressed: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => InventoryUpdateView(
                              products: _selectedProducts,
                            ),
                          ),
                        );
                        setState(() {
                          _selectedProducts = [];
                          _isSelectMode = false;
                        });
                      },
                      child: const Text('Update Inventory'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  ref
                      .read(productSearchQueryProvider.notifier)
                      .update((state) => value);
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ref.watch(productsStreamProvider).when(
                  data: (products) {
                    List<Product> productList = products;
                    final query = ref.watch(productSearchQueryProvider);

                    if (query.isNotEmpty) {
                      productList = products
                          .where((prod) => prod.name
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                          .toList();
                    }

                    if (productList.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('No products found.'),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: () {},
                            child: const Text('Add Product'),
                          ),
                        ],
                      );
                    }

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          clipBehavior: Clip.antiAlias,
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                          child: InkWell(
                            onTap: () {
                              if (_isSelectMode) {
                                _addProductToSelectedList(productList[index]);
                              } else {
                                _viewProduct(productList[index]);
                              }
                            },
                            child: ProductCard(
                              product: productList[index],
                              isSelected: _selectedProducts
                                  .contains(productList[index]),
                              isSelectMode: _isSelectMode,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: Text(
                        error.toString(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addProductToSelectedList(Product product) {
    if (_selectedProducts.contains(product)) {
      setState(() {
        _selectedProducts.remove(product);
      });
    } else {
      setState(() {
        _selectedProducts.add(product);
      });
    }
  }

  void _viewProduct(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductView(
          product: product,
        ),
      ),
    );
  }
}
