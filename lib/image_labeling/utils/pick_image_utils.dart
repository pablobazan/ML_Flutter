import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class PickImageUtils {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      return image;
    } catch (e) {
      if (kDebugMode) print(e);

      return null;
    }
  }

  Future<XFile?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image == null) return null;
      return image;
    } catch (e) {
      if (kDebugMode) print(e);
      return null;
    }
  }
}
