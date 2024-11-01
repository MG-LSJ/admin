import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:qr_earth_admin/ui/widgets/safe_padding.dart';
import 'package:qr_earth_admin/models/user.dart';
import 'package:qr_earth_admin/network/api_client.dart';
import 'package:flutter/material.dart';
import 'package:qr_earth_admin/utils/generate_bin_pdf.dart';

class BinsPage extends StatefulWidget {
  const BinsPage({super.key});

  @override
  State<BinsPage> createState() => _BinsPageState();
}

class _BinsPageState extends State<BinsPage> {
  static const _pageSize = 20;

  final PagingController<int, BinsEntry> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchBins(pageKey);
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Home Page'),
        title: const Text('Bins'),
        forceMaterialTransparency: true,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.goNamed("new-bin");
        },
        icon: const Icon(Icons.add),
        label: const Text('New Bin'),
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
              leading: Text('Preview'),
              title: Text('ID'),
              trailing: Text('Location'),
            ),
            Expanded(
              child: PagedListView<int, BinsEntry>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, item, index) => Card(
                    elevation: 0,
                    child: ListTile(
                      leading: IconButton(
                        onPressed: () => previewBinQR(item.id),
                        icon: const Icon(Icons.preview),
                      ),
                      title: Text(item.id),
                      trailing: Text(item.location),
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

  void previewBinQR(String binId) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(50),
          child: PdfPreview(
            canChangePageFormat: false,
            canChangeOrientation: false,
            canDebug: false,
            initialPageFormat: PdfPageFormat.a4,
            maxPageWidth: 500,
            build: (format) => generateBinPdf(binId),
            actions: [
              IconButton(
                onPressed: () => _savePdf(binId),
                icon: const Icon(Icons.save),
              ),
            ],
          ),
        );
      },
    );
  }

  _savePdf(String binId) async {
    var document = await generateBinPdf(binId);

    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: 'output-file.pdf',
      allowedExtensions: ['pdf'],
      type: FileType.custom,
    );

    if (outputFile != null) {
      File file = File(outputFile);
      await file.writeAsBytes(document);
    }
  }

  Future<void> _fetchBins(final int pageKey) async {
    final response = await ApiClient.listBins(
      page: pageKey,
      size: _pageSize,
    );

    if (response.statusCode == HttpStatus.ok) {
      Iterable binsResponse = response.data["items"];
      int page = response.data["page"];
      int totalPages = response.data["pages"];

      List<BinsEntry> binsList = List<BinsEntry>.from(
        binsResponse.map((x) => BinsEntry.fromJson(x)),
      );

      final isLastPage = page == totalPages;
      if (isLastPage) {
        _pagingController.appendLastPage(binsList);
      } else {
        final nextPageKey = page + 1;
        _pagingController.appendPage(binsList, nextPageKey);
      }
    }
  }
}
