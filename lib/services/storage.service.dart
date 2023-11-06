import 'dart:io';

import 'package:ucpc_inventory_management_app/exports.dart';

class StorageService {
  const StorageService._();

  static const StorageService _instance = StorageService._();
  static StorageService get instance => _instance;

  static final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File file, String productID) async {
    try {
      final String fileName = file.path.split('/').last;
      final Reference ref =
          _storage.ref().child('product-images/$productID/$fileName');
      final UploadTask uploadTask = ref.putFile(file);
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    } on Exception {
      rethrow;
    }
  }
}
