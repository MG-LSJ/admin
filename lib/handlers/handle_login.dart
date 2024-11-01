import 'package:qr_earth_admin/network/session.dart';
import 'package:qr_earth_admin/router/router.dart';
import 'package:qr_earth_admin/utils/globals.dart';

void handleLogin(Map<String, dynamic> response) async {
  isLoggedIn = true;

  Session.userAccessToken = response["access_token"];
  Session.userRefreshToken = response["refresh_token"];

  appRouter.goNamed('home');
}
