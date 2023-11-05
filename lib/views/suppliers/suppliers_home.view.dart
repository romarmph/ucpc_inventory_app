import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

class SuppliersHomeView extends ConsumerWidget {
  const SuppliersHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
      ),
      body: Container(),
    );
  }
}
