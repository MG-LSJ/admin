import 'dart:io';

import 'package:dio/dio.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:qr_earth_admin/handlers/handle_login.dart';
import 'package:qr_earth_admin/network/api_client.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();
  bool _showPassowrd = false;
  bool _wrongPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Form(
            key: _loginFormKey,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Welcome Back 👋",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Hello there, login to continue",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !_showPassowrd,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your Password",
                      prefixIcon: const Icon(
                        Icons.numbers,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassowrd
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPassowrd = !_showPassowrd;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password is required";
                      }
                      if (_wrongPassword) {
                        return "Wrong Passoword";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _login,
                    child: const Text("Log In"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    _wrongPassword = false;

    // trim
    _passwordController.text = _passwordController.text.trim();

    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        context.loaderOverlay.show();
      });

      try {
        final response = await ApiClient.login(
          password: _passwordController.text,
        );

        switch (response.statusCode) {
          case HttpStatus.ok:
            {
              return handleLogin(response.data);
            }
          case HttpStatus.unauthorized:
            {
              // Wrong password
              setState(() {
                _wrongPassword = true;
                context.loaderOverlay.hide();
              });
            }
            break;
          default:
            {
              // Something went wrong
              setState(() {
                context.loaderOverlay.hide();
              });
            }
        }

        _loginFormKey.currentState!.validate();
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
          }
          setState(() {
            context.loaderOverlay.hide();
          });
        } else {
          rethrow;
        }
      }
    }
  }
}
