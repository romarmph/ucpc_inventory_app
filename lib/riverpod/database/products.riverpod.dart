import 'package:ucpc_inventory_management_app/exports.dart';

final productsStreamProvider = StreamProvider<List<Product>>(
  (ref) => ProductDatabase.instance.getProducts(),
);

final productSearchQueryProvider = StateProvider<String>((ref) => '');
