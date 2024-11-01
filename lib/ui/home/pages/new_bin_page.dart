import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:qr_earth_admin/network/api_client.dart';
import 'package:qr_earth_admin/ui/widgets/safe_padding.dart';
import 'package:flutter/material.dart';
import 'package:qr_earth_admin/utils/generate_bin_pdf.dart';

class NewBinPage extends StatefulWidget {
  const NewBinPage({super.key});

  @override
  State<NewBinPage> createState() => _NewBinPageState();
}

class _NewBinPageState extends State<NewBinPage> {
  final _createBinFormKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();

  Uint8List? document;

  @override
  void initState() {
    super.initState();
    _locationController.text = 'cafeteria';
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Bin'),
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
            const Text("Create Bin"),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _createBinFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _locationController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: _generateBin,
                      child: const Text('Generate Bin'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (document != null)
              Expanded(
                child: PdfPreview(
                  canChangePageFormat: false,
                  canChangeOrientation: false,
                  canDebug: false,
                  initialPageFormat: PdfPageFormat.a4,
                  maxPageWidth: 500,
                  build: (format) => document!,
                  actions: [
                    IconButton(
                      onPressed: _savePdf,
                      icon: const Icon(Icons.save),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  _generateBin() async {
    if (_createBinFormKey.currentState!.validate()) {
      setState(() {
        context.loaderOverlay.show();
      });

      String location = _locationController.text;

      final response = await ApiClient.createBin(location: location);

      document = await generateBinPdf(response.data["id"]);

      setState(() {
        context.loaderOverlay.hide();
      });
    }
  }

  _savePdf() async {
    if (document != null) {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'output-file.pdf',
        allowedExtensions: ['pdf'],
        type: FileType.custom,
      );

      if (outputFile != null) {
        File file = File(outputFile);
        await file.writeAsBytes(document!);
      }
    }
  }
}
