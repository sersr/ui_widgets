import 'package:flutter/services.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

import 'permission.dart';

abstract class ImagePickerUtils {
  static final impagePicker = ImagePicker();
  static Future<String?> pickImage({
    bool isGallery = true,
    CameraDevice camera = CameraDevice.rear,
  }) async {
    if (!isGallery) {
      final granted = await PermissionChecker.requireCamera();
      if (!granted) {
        // final confirm = await showConfirm(context, 'camera_per_dialog'.tr);
        // if (!confirm) return null;
        // await PermissionChecker.openSettings();
        return null;
      }
    }

    final image = await impagePicker.pickImage(
      imageQuality: 88,
      preferredCameraDevice: camera,
      source: isGallery ? ImageSource.gallery : ImageSource.camera,
    );

    return image?.path;
  }

  static Future<String> savePicture(Uint8List bytes, String name) async {
    final result = await ImageGallerySaverPlus.saveImage(bytes, name: name);
    if (result case {'filePath': String filePath}) {
      return filePath;
    }
    return '';
  }
}
