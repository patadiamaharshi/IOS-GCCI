import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermission(Permission permission) async {
  final PermissionStatus status = await permission.request();

  if (status.isGranted) {
    //print("${permission.toString().split('.').last} permission granted.");
  } else if (status.isDenied) {
    //print("${permission.toString().split('.').last} permission denied.");
  } else if (status.isPermanentlyDenied) {
    //print("${permission.toString().split('.').last} permission permanently denied. Opening settings...");
    //await openAppSettings();
  }
}

Future<void> requestMultiplePermissions() async {
  Map<Permission, PermissionStatus> statuses =
      await [
        Permission.notification,
        Permission.camera,
      //  Permission.microphone,
       // Permission.location,
      ].request();

  // Handle permissions individually
  if (statuses[Permission.notification]!.isGranted) {
    //print("Notification permission granted.");
  }

  if (statuses[Permission.camera]!.isGranted) {
    //print("Camera permission granted.");
  }

  if (statuses[Permission.microphone]!.isGranted) {
    //print("Microphone permission granted.");
  }

  if (statuses[Permission.location]!.isGranted) {
   // print("Location permission granted.");
  }

  // Check if any permission is permanently denied and open settings
  if (statuses.values.any((status) => status.isPermanentlyDenied)) {
    //print("Some permissions are permanently denied. Opening settings...");
   // await openAppSettings();
  }
}
