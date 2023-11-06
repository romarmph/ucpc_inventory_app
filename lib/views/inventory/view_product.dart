import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

class ProductView extends ConsumerWidget {
  const ProductView({
    super.key,
    this.productId,
  });

  final String? productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(productId ?? 'Product'),
      ),
    );
  }
}
