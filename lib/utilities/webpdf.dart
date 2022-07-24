import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';

import 'package:mug_together/utilities/pdf.dart';

class WebPDF implements PDFcreator {
  
  @override
  void download(Uint8List bytes, String name) {
    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64Encode(bytes)}")
      ..setAttribute("download", "$name.pdf")
      ..click();
  }
}

PDFcreator getPDFcreator() => WebPDF();