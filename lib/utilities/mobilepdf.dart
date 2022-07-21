import 'dart:io';
import 'dart:typed_data';

import 'package:mug_together/utilities/pdf.dart';
import 'package:path_provider/path_provider.dart';

class MobilePDF implements PDFcreator {
  @override
  void download(Uint8List bytes, String name) {
    getExternalStorageDirectory().then((value) {
      File('${value!.path}/$name.pdf').writeAsBytes(bytes);
    });
  }
}

PDFcreator getPDFcreator() => MobilePDF();