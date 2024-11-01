import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:qr_earth_admin/ui/widgets/global_scaffold.dart';

class AuthScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AuthScreen({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('AuthScreen'));

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      child: LoaderOverlay(child: navigationShell),
    );
  }
}
