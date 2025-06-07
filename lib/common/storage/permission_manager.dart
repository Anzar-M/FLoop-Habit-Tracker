import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../mobile/screens/home_screen.dart';

class PermissionManager extends StatefulWidget {
  @override
  _PermissionManagerState createState() => _PermissionManagerState();
}

class _PermissionManagerState extends State<PermissionManager> {
  bool _isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    // Delay permission check until after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermission();
    });
  }

  Future<void> _checkPermission() async {
    final permission = await _getRequiredPermission();
    final status = await permission.status;

    if (!mounted) return;

    if (status.isGranted) {
      _navigateToHome();
    } else {
      setState(() {
        _isPermissionGranted = false;
      });
    }
  }

  Future<Permission> _getRequiredPermission() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final androidInfo = await deviceInfoPlugin.androidInfo;
    final isAndroid11OrAbove = androidInfo.version.sdkInt >= 30;

    return isAndroid11OrAbove
        ? Permission.manageExternalStorage
        : Permission.storage;
  }

  Future<void> _requestPermission() async {
    final permission = await _getRequiredPermission();
    final status = await permission.request();

    if (!mounted) return;

    if (status.isGranted) {
      _navigateToHome();
    } else {
      setState(() {
        _isPermissionGranted = false;
      });
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Storage Permission'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Storage permission is required to proceed.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _requestPermission,
              child: Text(
                'Grant Permission',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}