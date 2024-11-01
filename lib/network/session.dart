import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class Session {
  static final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  static const String _userAccessTokenKey = 'user_access_token';
  static const String _userRefreshTokenKey = 'user_refresh_token';

  static String? _userAccessToken;
  static String? _userRefreshToken;

  static String? get userAccessToken => _userAccessToken;
  static String? get userRefreshToken => _userRefreshToken;

  static Future<void> init() async {
    if (kDebugMode) debugPrint("Initializing session");
    _userAccessToken = await prefs.getString(_userAccessTokenKey);
    _userRefreshToken = await prefs.getString(_userRefreshTokenKey);
  }

  static set userAccessToken(String? token) {
    _userAccessToken = token;
    if (kDebugMode) debugPrint("Saved access token");
    prefs.setString(_userAccessTokenKey, token ?? '');
  }

  static set userRefreshToken(String? token) {
    _userRefreshToken = token;
    if (kDebugMode) debugPrint("Saved refresh token");
    prefs.setString(_userRefreshTokenKey, token ?? '');
  }

  static void clear() async {
    if (kDebugMode) debugPrint("Clearing session");
    _userAccessToken = null;
    _userRefreshToken = null;
    await prefs.remove(_userAccessTokenKey);
    await prefs.remove(_userRefreshTokenKey);
  }
}
