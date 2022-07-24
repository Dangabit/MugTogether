import 'dart:io';
import 'dart:typed_data';

import 'package:mug_together/utilities/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MobilePDF implements PDFcreator {
  @override
  void download(Uint8List bytes, String name) {
    Permission.storage.request().then((perm) async {
      if (perm.isGranted) {
        await getExternalStorageDirectory().then((value) {
          File('${value!.path}/$name.pdf').writeAsBytes(bytes);
        });
      } else if (perm.isPermanentlyDenied) {
        await openAppSettings();
      }
    });
  }
}

PDFcreator getPDFcreator() => MobilePDF();
