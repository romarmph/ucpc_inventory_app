import 'package:ucpc_inventory_management_app/exports.dart';

class ProductDatabase {
  const ProductDatabase._();

  static const ProductDatabase _instance = ProductDatabase._();
  static ProductDatabase get instance => _instance;

  static final _firestore = FirebaseFirestore.instance;
  static final _productsRef = _firestore.collection('products');

  Future<String> addProduct(Product product) async {
    return await _productsRef.add(product.toJson()).then((value) => value.id);
  }

  Future<void> updateProduct(Product product) async {
    print(product.id);
    await _productsRef.doc(product.id).update(product.toJson());
  }

  Future<void> addImageUrl(String url, String productId) async {
    await _productsRef.doc(productId).update({
      'imageUrls': FieldValue.arrayUnion([url])
    });
  }

  Future<void> deleteProduct(String id) async {
    await _productsRef.doc(id).delete();
  }

  Future<Product> getProductById(String id) async {
    final product = await _productsRef.doc(id).get();
    return Product.fromJson(product.data()!, product.id);
  }

  Stream<List<Product>> getProducts() {
    return _productsRef
        .where('isHidden', isEqualTo: false)
        .orderBy('isPopular', descending: true)
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((product) {
        return Product.fromJson(product.data(), product.id);
      }).toList();
    });
  }
}
