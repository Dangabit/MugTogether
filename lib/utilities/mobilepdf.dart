import 'dart:io';
import 'dart:typed_data';

import 'package:mug_together/utilities/pdf.dart';
import 'package:permission_handler/permission_handler.dart';

class MobilePDF implements PDFcreator {
  @override
  void download(Uint8List bytes, String name) {
    Permission.storage.request().then((perm) async {
      if (perm.isGranted) {
        final download = Directory("/storage/emulated/0/Download");
        File('${download.path}/$name.pdf')
            .writeAsBytes(bytes)
            .whenComplete(() => print("ping"))
            .onError((error, stackTrace) {
          print(error);
          throw Exception("Fail");
        });
      } else if (perm.isPermanentlyDenied) {
        await openAppSettings();
      }
    });
  }
}

PDFcreator getPDFcreator() => MobilePDF();
