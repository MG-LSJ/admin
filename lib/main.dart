import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:qr_earth_admin/app.dart';
import 'package:qr_earth_admin/network/api_client.dart';
import 'package:flutter/material.dart';
import 'package:qr_earth_admin/utils/is_desktop.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.init();
  runApp(const App());

  if (isDesktop) {
    doWhenWindowReady(() {
      const initialSize = Size(600, 450);
      appWindow.minSize = initialSize;
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
      appWindow.show();
    });
  }
}
