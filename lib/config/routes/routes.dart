import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

final Map<String, Widget Function(BuildContext)> myRoutes = {
  Routes.home: (context) => const Wrapper(),
  Routes.login: (context) => const LoginPage(),
  Routes.inventory: (context) => const InventoryHomeView(),
  Routes.orders: (context) => const OrdersHomeView(),
  Routes.suppliers: (context) => const SuppliersHomeView(),
  Routes.users: (context) => const UsersHomeView(),
  Routes.addProduct: (context) => const ProductAddView(),
  Routes.barcodeScanner: (context) => const BarcodeScanner(),
  Routes.productView: (context) => const ProductView(),
};
