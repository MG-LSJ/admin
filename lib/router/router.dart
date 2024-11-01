import 'package:qr_earth_admin/ui/auth/routes.dart';
import 'package:qr_earth_admin/ui/home/routes.dart';
import 'package:qr_earth_admin/ui/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_earth_admin/utils/globals.dart';

GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/splash',
  debugLogDiagnostics: false,
  routes: <RouteBase>[
    GoRoute(
      name: "splash",
      path: "/splash",
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SplashScreen(),
      ),
    ),
    authRoute,
    homeRoute,
  ],
  redirect: (context, state) {
    bool onSplash = state.fullPath == '/splash';
    bool onLoginPage = state.fullPath == '/login';

    if (onSplash) {
      return null;
    }

    if (!isLoggedIn && !onLoginPage) {
      return '/login';
    }

    if (isLoggedIn && onLoginPage) {
      return '/home';
    }

    return null;
  },
);
