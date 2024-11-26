import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PermissionUtils {
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;

      if (androidInfo.version.sdkInt >= 33) {
        // Android 13 and above
        final photos = await Permission.photos.status;
        if (photos.isGranted) return true;

        final result = await Permission.photos.request();
        return result.isGranted;
      } else {
        // Android 12 and below
        final storage = await Permission.storage.status;
        if (storage.isGranted) return true;

        final result = await Permission.storage.request();
        return result.isGranted;
      }
    }

    // iOS handling
    return await requestIOSPhotosPermission();
  }


  static Future<bool> requestAndroidStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    } else {
      status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  static Future<bool> requestAndroidPhotosPermission() async {
    var status = await Permission.photos.status;
    if (status.isGranted) {
      return true;
    } else {
      status = await Permission.photos.request();
      return status.isGranted;
    }
  }

  static Future<bool> requestIOSPhotosPermission() async {
    var status = await Permission.photos.status;
    if (status.isGranted) {
      return true;
    } else {
      status = await Permission.photos.request();
      return status.isGranted;
    }
  }

  static Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    } else {
      status = await Permission.camera.request();
      return status.isGranted;
    }
  }

  static Future<bool> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      return true;
    } else {
      status = await Permission.location.request();
      return status.isGranted;
    }
  }
}
