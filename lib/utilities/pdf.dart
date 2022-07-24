import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:mug_together/models/question.dart';
import 'package:mug_together/utilities/pdf_stub.dart'
    if (dart.library.html) 'package:mug_together/utilities/webpdf.dart'
    if (dart.library.io) 'package:mug_together/utilities/mobilepdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

abstract class PDFcreator {
  /// Function to download the pdf
  void download(Uint8List bytes, String name) {}

  factory PDFcreator() => getPDFcreator();

  static Future<void> createPDF(Question question, String name) async {
    final pdf = pw.Document();
    final image = (await rootBundle.load("assets/images/logo-nobg.png"))
        .buffer
        .asUint8List();
    pdf.addPage(pw.Page(
        build: (context) {
          return pw.Column(children: [
            pw.Center(child: pw.Image(pw.MemoryImage(image))),
            pw.Center(child: pw.Text("MugTogether")),
            pw.SizedBox(height: 1.0),
            pw.Text(question.data["Question"], textScaleFactor: 2.0),
            pw.Container(
                child: pw.Text(question.data["Notes"]),
                padding: const pw.EdgeInsets.all(2.0),
                decoration: pw.BoxDecoration(border: pw.Border.all())),
          ]);
        },
        pageFormat: PdfPageFormat.a4));
    return pdf.save().then((byte) {
      PDFcreator().download(byte, name);
    });
  }
}
