import 'dart:io';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:qr_earth_admin/ui/widgets/safe_padding.dart';
import 'package:qr_earth_admin/models/user.dart';
import 'package:qr_earth_admin/network/api_client.dart';
import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  int totalUsers = 0;
  static const _pageSize = 10;

  final PagingController<int, LeaderboardEntry> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _fetchTotalUsers();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchLeaderboard(pageKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboards'),
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
            TextButton.icon(
              onPressed: _pagingController.refresh,
              label: const Text('Refresh'),
              icon: const Icon(Icons.refresh),
            ),
            const ListTile(
              leading: Text('Rank'),
              title: Text('Username'),
              trailing: Text('Recycled'),
            ),
            Expanded(
              child: PagedListView<int, LeaderboardEntry>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, item, index) => Card(
                    elevation: 0,
                    child: ListTile(
                      leading: Text('${index + 1} / $totalUsers'),
                      title: Text('@${item.username}'),
                      trailing: Text(item.redeemedCodeCount.toString()),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _fetchLeaderboard(final int pageKey) async {
    final response = await ApiClient.leaderboard(
      page: pageKey,
      size: _pageSize,
    );

    if (response.statusCode == HttpStatus.ok) {
      Iterable leaderboardResponse = response.data["items"];
      int page = response.data["page"];
      int totalPages = response.data["pages"];

      List<LeaderboardEntry> leaderboardList = List<LeaderboardEntry>.from(
        leaderboardResponse.map((x) => LeaderboardEntry.fromJson(x)),
      );

      final isLastPage = page == totalPages;
      if (isLastPage) {
        _pagingController.appendLastPage(leaderboardList);
      } else {
        final nextPageKey = page + 1;
        _pagingController.appendPage(leaderboardList, nextPageKey);
      }
    }
  }

  void _fetchTotalUsers() async {
    final response = await ApiClient.totalUsers();

    if (response.statusCode == HttpStatus.ok) {
      totalUsers = response.data;
      setState(() {});
    }
  }
}
