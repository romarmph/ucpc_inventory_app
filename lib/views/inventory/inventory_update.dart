import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';
import 'package:ucpc_inventory_management_app/views/inventory/widget/inventory_update_list_tile.dart';

class InventoryUpdateView extends ConsumerWidget {
  const InventoryUpdateView({
    Key? key,
    this.products,
  }) : super(key: key);

  final List<Product>? products;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Inventory'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await _updateProducts(ref);
              _pop();
            },
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products!.length,
        itemBuilder: (context, index) {
          return InventoryUpdateListTile(
            product: products![index],
          );
        },
      ),
    );
  }

  Future<void> _updateProducts(WidgetRef ref) async {
    final updatedProducts = ref.watch(updatedProductsProvider);
    _showLoadingDialog();
    for (var product in updatedProducts) {
      await ProductDatabase.instance.updateProduct(product);
    }
    _pop();
  }

  void _showLoadingDialog() {
    QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.loading,
      title: 'Updating Products',
      text: 'Please wait...',
    );
  }

  void _pop() {
    Navigator.of(navigatorKey.currentContext!).pop();
  }
}

final updatedProductsProvider = StateProvider<List<Product>>((ref) {
  return [];
});
