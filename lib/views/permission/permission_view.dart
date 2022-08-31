import 'package:demo_flutter_app/utils/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class PermissionView extends StatelessWidget with PermissionManagerMixin{
  const PermissionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        toolbarHeight: 100,
        title: const Text("Permissions"),
        leading: const Icon(Icons.arrow_back),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              await requestPermissions([Permission.phone, Permission.microphone]);
            },
            child: const Text("Request SMS Permission"),
          )
        ],
      ),
    );
  }

  @override
  void onPermissionDenied(Permission permission) {
    print("on permission denied");
  }

  @override
  void onPermissionGranted() {
    print("on permission granted");
  }

  @override
  void onPermissionPermanentlyDenied(Permission permission) {
    openAppSettings();
  }
}
