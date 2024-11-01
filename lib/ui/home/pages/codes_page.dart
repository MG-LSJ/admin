import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:qr_earth_admin/network/api_client.dart';
import 'package:qr_earth_admin/ui/widgets/safe_padding.dart';
import 'package:flutter/material.dart';
import 'package:qr_earth_admin/utils/generate_codes_pdf.dart';

class CodesPage extends StatefulWidget {
  const CodesPage({super.key});

  @override
  State<CodesPage> createState() => _CodesPageState();
}

class _CodesPageState extends State<CodesPage> {
  final _createQrCodeFormKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
  final _quantityController = TextEditingController();

  Uint8List? document;

  @override
  void initState() {
    super.initState();
    _valueController.text = '10';
    _quantityController.text = '10';
  }

  @override
  void dispose() {
    _valueController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Home Page'),
        title: const Text('Codes'),
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
            const Text("Generate Qr codes"),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: _createQrCodeFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _valueController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Value',
                      ),
                    ),
                    TextFormField(
                      controller: _quantityController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: _generateCodes,
                      child: const Text('Generate Codes'),
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

  _generateCodes() async {
    if (_createQrCodeFormKey.currentState!.validate()) {
      setState(() {
        context.loaderOverlay.show();
      });

      int value = int.parse(_valueController.text);
      int quantity = int.parse(_quantityController.text);

      if (value < 1 || quantity < 1) {
        context.loaderOverlay.hide();
        return;
      }

      final response = await ApiClient.generateCodes(
        value: value,
        quantity: quantity,
      );

      document = await generateCodesPdf(response.data);

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
