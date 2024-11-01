import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_earth_admin/utils/colors.dart';
import 'package:qr_earth_admin/utils/is_desktop.dart';

class GlobalScaffold extends StatelessWidget {
  final Widget child;
  const GlobalScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Theme.of(context).brightness,
          systemNavigationBarColor: Theme.of(context).colorScheme.surface,
          statusBarBrightness: Theme.of(context).brightness,
          statusBarColor: Theme.of(context).colorScheme.surface,
        ),
      ),
      body: Column(
        children: [
          if (isDesktop)
            WindowTitleBarBox(
              child: Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        WindowTitleBarBox(
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              Image.asset(
                                "assets/images/logo.png",
                                width: 25,
                                height: 25,
                              ),
                              const Text(
                                "QR Earth",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: keyColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        MoveWindow(),
                      ],
                    ),
                  ),
                  MinimizeWindowButton(
                    colors: WindowButtonColors(
                      iconNormal: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  MaximizeWindowButton(
                    colors: WindowButtonColors(
                      iconNormal: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  CloseWindowButton(
                    colors: WindowButtonColors(
                      iconNormal: Theme.of(context).colorScheme.onSurface,
                      mouseOver: Colors.red.shade700,
                      mouseDown: Colors.red.shade700,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
