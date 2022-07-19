import 'dart:io';

import 'package:flutter/services.dart';
import 'package:mug_together/models/question.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFcreator {
  static Future<File> createPDF(Question question, String name) async {
    final pdf = pw.Document();
    final image =
        (await rootBundle.load("assets/images/logo3.png")).buffer.asUint8List();
    pdf.addPage(pw.Page(
        build: (context) {
          return pw.Column(children: [
            pw.Center(child: pw.Image(pw.MemoryImage(image))),
            pw.Center(child: pw.Text("MugTogether")),
            pw.Text(question.data["Question"], textScaleFactor: 2.0),
            pw.Container(
                child: pw.Text(question.data["Notes"]),
                padding: const pw.EdgeInsets.all(2.0),
                decoration: pw.BoxDecoration(border: pw.Border.all())),
          ]);
        },
        pageFormat: PdfPageFormat.a4));
    return pdf.save().then((byte) async {
      final output = await getTemporaryDirectory();
      return File('${output.path}/$name.pdf').writeAsBytes(byte);
    });
  }
}
