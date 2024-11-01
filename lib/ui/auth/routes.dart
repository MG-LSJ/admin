import 'package:qr_earth_admin/ui/auth/pages/log_in_page.dart';
import 'package:qr_earth_admin/ui/auth/screen.dart';
import 'package:go_router/go_router.dart';

StatefulShellRoute authRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return AuthScreen(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "login",
          path: "/login",
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const LoginPage(),
          ),
        ),
      ],
    ),
  ],
);
