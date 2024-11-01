import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateBinPdf(String code) async {
  // contact card layout
  // 7 rows 5 columns

  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisSize: pw.MainAxisSize.max,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'QR Earth Bin',
                style: pw.TextStyle(
                  fontSize: 69,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Expanded(
                child: pw.BarcodeWidget(
                  data: code,
                  barcode: pw.Barcode.qrCode(),
                ),
              ),
            ],
          ),
        );
      },
    ),
  ); // Page

  return pdf.save();
}
