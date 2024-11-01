import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:qr_earth_admin/network/api_factory.dart';
import 'package:qr_earth_admin/network/api_routes.dart';

///ApiClient class is a wrapper for the ApiFactory class.
///
///It contains static methods that call the ApiFactory methods.
class ApiClient {
  static Future<void> init() async {
    await ApiFactory.init();
  }

  // admin
  static Future<Response> login({
    required String password,
  }) async {
    return ApiFactory.post(
      ApiRoutes.adminLogin,
      auth: false,
      data: jsonEncode({
        "password": password,
      }),
    );
  }

  static Future<Response> sessionValid() {
    return ApiFactory.get(
      ApiRoutes.adminSessionValid,
      auth: true,
    );
  }

  // public
  static Future<Response> leaderboard({
    required int page,
    required int size,
  }) async {
    return ApiFactory.get(
      ApiRoutes.leaderboard,
      auth: false,
      queryParameters: {
        "page": page,
        "size": size,
      },
    );
  }

  static Future<Response> totalUsers() async {
    return ApiFactory.get(
      ApiRoutes.totalUsers,
      auth: false,
    );
  }

  // bins
  static Future<Response> binInfo({
    required String binId,
  }) async {
    return ApiFactory.get(
      ApiRoutes.binInfo,
      auth: false,
      queryParameters: {
        "bin_id": binId,
      },
    );
  }

  static Future<Response> redeemUserPoints({
    required String userId,
    required int points,
  }) {
    return ApiFactory.post(
      ApiRoutes.adminRedeemUserPoints,
      auth: true,
      data: jsonEncode({
        "user_id": userId,
        "points": points,
      }),
    );
  }

  static Future<Response> createBin({
    required String location,
  }) {
    return ApiFactory.post(
      ApiRoutes.adminCreateBin,
      auth: true,
      queryParameters: {
        "location": location,
      },
    );
  }

  static Future<Response> generateCodes({
    required int value,
    required int quantity,
  }) {
    return ApiFactory.get(
      ApiRoutes.adminGenerateCodes,
      auth: true,
      queryParameters: {
        "value": value,
        "quantity": quantity,
      },
    );
  }

  static Future<Response> listBins({
    required int page,
    required int size,
  }) async {
    return ApiFactory.get(
      ApiRoutes.adminListBins,
      auth: true,
      queryParameters: {
        "page": page,
        "size": size,
      },
    );
  }
}
