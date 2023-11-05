import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

class OrdersHomeView extends ConsumerWidget {
  const OrdersHomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: Container(),
    );
  }
}
