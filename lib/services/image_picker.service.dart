import 'dart:io';
import 'package:ucpc_inventory_management_app/exports.dart';

class ImagePickerService {
  const ImagePickerService._();

  static const ImagePickerService _instance = ImagePickerService._();
  static ImagePickerService get instance => _instance;

  static final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
        preferredCameraDevice: CameraDevice.rear,
        maxHeight: 400,
        maxWidth: 400,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }

      return null;
    } on Exception {
      rethrow;
    }
  }
}
