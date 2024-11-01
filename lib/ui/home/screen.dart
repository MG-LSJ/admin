import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:qr_earth_admin/ui/widgets/global_scaffold.dart';
import 'package:qr_earth_admin/utils/colors.dart';

class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const HomeScreen({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('HomeScreen'));

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      child: AdaptiveScaffold(
        transitionDuration: Duration.zero,
        appBar: AppBar(
          titleSpacing: 0,
          title: Row(
            children: [
              Image.asset("assets/images/logo.png", width: 40, height: 40),
              const Text(
                'QR Earth Admin',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: keyColor,
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(
              color: Theme.of(context).dividerColor,
              height: 0.5,
            ),
          ),
          systemOverlayStyle: plainSystemUiOverlayStyle(context),
        ),
        // appBarBreakpoint: Breakpoints.smallAndUp,
        body: (_) => LoaderOverlay(
          child: navigationShell,
        ),
        selectedIndex: navigationShell.currentIndex,
        destinations: const [
          NavigationDestination(
            label: 'Home',
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
          ),
          NavigationDestination(
            label: 'Leaderboard',
            icon: Icon(Icons.leaderboard_outlined),
            selectedIcon: Icon(Icons.leaderboard),
          ),
          NavigationDestination(
            label: 'Codes',
            icon: Icon(Icons.qr_code_outlined),
            selectedIcon: Icon(Icons.qr_code),
          ),
          NavigationDestination(
            label: 'Bins',
            icon: Icon(Icons.delete_outline),
            selectedIcon: Icon(Icons.delete),
          ),
          NavigationDestination(
            label: 'Settings',
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
          ),
        ],
        onSelectedIndexChange: _goBranch,
      ),
    );
  }
}
