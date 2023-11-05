import 'package:ucpc_inventory_management_app/exports.dart';

class ProductDatabase {
  const ProductDatabase._();

  static const ProductDatabase _instance = ProductDatabase._();
  static ProductDatabase get instance => _instance;

  static final _firestore = FirebaseFirestore.instance;
  static final _productsRef = _firestore.collection('products');

  Future<void> addProduct(Product product) async {
    await _productsRef.add(product.toJson());
  }

  Future<void> updateProduct(Product product) async {
    await _productsRef.doc(product.id).update(product.toJson());
  }

  Future<void> deleteProduct(String id) async {
    await _productsRef.doc(id).delete();
  }

  Stream<List<Product>> getProducts() {
    return _productsRef
        .where('isHidden', isEqualTo: false)
        .orderBy('name')
        .orderBy('isPopular')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((product) {
        return Product.fromJson(product.data(), product.id);
      }).toList();
    });
  }
}
