import 'package:flutter/material.dart';
import 'package:qr_earth_admin/ui/home/pages/bins_page.dart';
import 'package:qr_earth_admin/ui/home/pages/codes_page.dart';
import 'package:qr_earth_admin/ui/home/pages/home_page.dart';
import 'package:qr_earth_admin/ui/home/pages/leaderboard_page.dart';
import 'package:qr_earth_admin/ui/home/pages/new_bin_page.dart';
import 'package:qr_earth_admin/ui/home/pages/settings_page.dart';
import 'package:qr_earth_admin/ui/home/screen.dart';
import 'package:go_router/go_router.dart';

StatefulShellRoute homeRoute = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return HomeScreen(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "home",
          path: "/home",
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const HomePage(),
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "leaderboard",
          path: "/leaderboard",
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const LeaderboardPage(),
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "codes",
          path: "/codes",
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const CodesPage(),
          ),
        ),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
            name: "bins",
            path: "/bins",
            pageBuilder: (context, state) => MaterialPage<void>(
                  key: state.pageKey,
                  child: const BinsPage(),
                ),
            routes: [
              GoRoute(
                name: "new-bin",
                path: "/new",
                pageBuilder: (context, state) => MaterialPage<void>(
                  key: state.pageKey,
                  child: const NewBinPage(),
                ),
              ),
            ]),
      ],
    ),
    StatefulShellBranch(
      routes: [
        GoRoute(
          name: "settings",
          path: "/settings",
          pageBuilder: (context, state) => MaterialPage<void>(
            key: state.pageKey,
            child: const SettingsPage(),
          ),
        ),
      ],
    ),
  ],
);
