import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Future<File> pickImages() async {
  File images = File("");
  try {
    var files = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (files != null && files.files.isNotEmpty) {
      images = (File(files.files[0].path!));
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return images;
}
