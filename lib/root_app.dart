import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RootApp extends StatefulWidget {
  const RootApp({super.key});

  @override
  State<RootApp> createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  String deviceName = '';
  String deviceVersion = '';
  String deviceID = '';

  Future<void> getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var dataAndroid = await deviceInfoPlugin.androidInfo;
        setState(() {
          deviceName = dataAndroid.model;
          deviceVersion = dataAndroid.version.release;
          deviceID = dataAndroid.id;
        });
      } else if (Platform.isIOS) {
        var dataIos = await deviceInfoPlugin.iosInfo;
        setState(() {
          deviceName = dataIos.model;
          deviceVersion = dataIos.systemVersion;
          deviceID = dataIos.identifierForVendor.toString();
        });
      }
    } on PlatformException {
      print('Failed to platform exception');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finding Device Information')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  getDeviceInfo();
                },
                child: const Text('Get Device Info')),
            deviceID.isNotEmpty &&
                    deviceName.isNotEmpty &&
                    deviceVersion.isNotEmpty
                ? Column(
                    children: [
                      const SizedBox(height: 20),
                      Text('Device Name: $deviceName'),
                      const SizedBox(height: 20),
                      Text('Device Version: $deviceVersion'),
                      const SizedBox(height: 20),
                      Text('Device ID: $deviceID')
                    ],
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
