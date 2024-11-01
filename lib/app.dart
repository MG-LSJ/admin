import 'package:qr_earth_admin/router/router.dart';
import 'package:qr_earth_admin/utils/colors.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'QR Earth Admin',
      onGenerateTitle: (context) => 'QR Earth Admin',
      routerConfig: appRouter,
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
