import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  RouteNames.home: (context) => const HomePage(),
  RouteNames.login: (context) => const LoginPage(),
};
