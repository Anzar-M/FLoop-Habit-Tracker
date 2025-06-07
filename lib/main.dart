import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'common/themes/app_theme.dart';
import 'common/storage/permission_manager.dart';
import 'mobile/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PermissionManagerWrapper(),
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}

class PermissionManagerWrapper extends StatefulWidget {
  @override
  _PermissionManagerWrapperState createState() => _PermissionManagerWrapperState();
}

class _PermissionManagerWrapperState extends State<PermissionManagerWrapper> {
  bool? _isPermissionGranted; // null while loading

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    final permission = sdkInt >= 30
        ? Permission.manageExternalStorage
        : Permission.storage;

    final status = await permission.status;

    setState(() {
      _isPermissionGranted = status.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isPermissionGranted == null) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_isPermissionGranted == true) {
      return HomeScreen();
    } else {
      return PermissionManager();
    }
  }
}
