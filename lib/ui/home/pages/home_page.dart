import 'dart:io';

import 'package:qr_earth_admin/network/api_client.dart';
import 'package:qr_earth_admin/ui/widgets/safe_padding.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _totalUsers = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        forceMaterialTransparency: true,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafePadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Total Users: $_totalUsers"),
          ],
        ),
      ),
    );
  }

  void _loadData() {
    _fetchTotalUsers();
  }

  void _fetchTotalUsers() async {
    final response = await ApiClient.totalUsers();

    if (response.statusCode == HttpStatus.ok) {
      _totalUsers = response.data;
      setState(() {});
    }
  }
}
