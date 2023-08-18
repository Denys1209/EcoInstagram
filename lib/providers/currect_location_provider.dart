import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class CurrentLocationProvider with ChangeNotifier {
  Future<Position?> getCurrentLocation() async {
    PermissionStatus permissionStatus = await Permission.location.status;

    if (permissionStatus.isDenied) {
      permissionStatus = await Permission.location.request();

      if (permissionStatus.isDenied) {
        return null;
      }
    }

    if (permissionStatus.isGranted) {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    }

    return null;
  }
}
