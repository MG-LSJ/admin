import 'package:qr_earth_admin/network/session.dart';
import 'package:qr_earth_admin/router/router.dart';
import 'package:qr_earth_admin/utils/globals.dart';

void handleLogout({String? message}) {
  // Clear user session
  Session.clear();

  isLoggedIn = false;
  // Navigate to login screen
  appRouter.goNamed("login");
}
