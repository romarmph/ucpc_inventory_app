import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

class InventoryHomeView extends ConsumerWidget {
  const InventoryHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Products',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.addProduct);
                  },
                  child: const Text('Add Product'),
                ),
              ],
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
                      return ProductCard(product: productList[index]);
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
    );
  }
}
