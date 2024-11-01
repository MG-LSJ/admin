import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateCodesPdf(List codes) async {
  // contact card layout
  // 7 rows 5 columns
  int pages = (codes.length / 35).ceil();
  int index = 0;

  final pdf = pw.Document();
  for (int page = 0; page < pages; page++) {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.GridView(
              crossAxisCount: 5,
              children: List.generate(
                35,
                (i) {
                  if (index < codes.length) {
                    final code = codes[index]["id"];
                    index++;
                    return pw.Container(
                      margin: const pw.EdgeInsets.all(10),
                      child: pw.BarcodeWidget(
                        data: code,
                        barcode: pw.Barcode.qrCode(),
                        width: 50,
                        height: 50,
                      ),
                    );
                  } else {
                    return pw.Container();
                  }
                },
              ),
            ),
          ); // Center
        },
      ),
    ); // Page
  }

  return pdf.save();
}
