import 'package:permission_handler/permission_handler.dart';

mixin PermissionManagerMixin {
  void onPermissionGranted();

  void onPermissionDenied(Permission permission);

  void onPermissionPermanentlyDenied(Permission permission);

  void updateStatus(permission, PermissionStatus status, {required bool checkDenied}) {
    if (status.isPermanentlyDenied || status.isRestricted) {
      onPermissionPermanentlyDenied(permission);
    }
    if (status.isGranted || status.isLimited) {
      onPermissionGranted();
    }
    if (checkDenied && status.isDenied) {
      onPermissionDenied(permission);
    }
  }

  void requestPermission(Permission permission) async {
    final status = await permission.status;
    updateStatus(permission, status, checkDenied: false);
    if (status == PermissionStatus.denied) {
      final newStatus = await permission.request();
      updateStatus(permission, newStatus, checkDenied: true);
    }
  }

  Future<void> requestPermissions(List<Permission> permissions) async {
    Map<Permission, PermissionStatus> statuses = await permissions.request();

    bool isPermissionGranted = true;

    for(var item in statuses.entries){
      if(item.value == PermissionStatus.denied){
        onPermissionDenied(item.key);
        isPermissionGranted = false;
        return;
      }else if(item.value == PermissionStatus.permanentlyDenied){
        onPermissionPermanentlyDenied(item.key);
        isPermissionGranted = false;
        return;
      }
    }

    if(isPermissionGranted){
      onPermissionGranted();
    }
  }
}