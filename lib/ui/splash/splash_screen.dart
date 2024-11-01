import 'dart:io';
import 'package:dio/dio.dart';
import 'package:qr_earth_admin/handlers/handle_logout.dart';
import 'package:qr_earth_admin/network/api_client.dart';
import 'package:qr_earth_admin/network/session.dart';
import 'package:qr_earth_admin/ui/widgets/global_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_earth_admin/utils/globals.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalScaffold(
      child: Center(
        child: Image.asset(
          'assets/images/banner.png',
          width: 300,
        ),
      ),
    );
  }

  void whereToGo() async {
    if (Session.userAccessToken != null) {
      try {
        final response = await ApiClient.sessionValid();

        print('Session valid response: $response');
        if (response.statusCode == HttpStatus.ok) {
          isLoggedIn = true;
          if (mounted) return context.goNamed('home');
        }
      } on DioException catch (e) {
        if (e.type == DioExceptionType.connectionError) {
          if (mounted) {
            showAdaptiveDialog(
              context: context,
              builder: (context) {
                return AlertDialog.adaptive(
                  title: const Text('Connection Error'),
                  content: const Text(
                      'Unable to connect to the server. Please check your internet connection and try again.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        whereToGo();
                      },
                      child: const Text('Retry'),
                    ),
                    TextButton(
                      onPressed: () => exit(1),
                      child: const Text(
                        'Exit',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
            return;
          }
        } else {
          rethrow;
        }
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      handleLogout();
    });
  }
}
