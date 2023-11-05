import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  Routes.home: (context) => const Wrapper(),
  Routes.login: (context) => const LoginPage(),
};
