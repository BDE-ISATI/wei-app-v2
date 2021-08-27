import 'dart:typed_data';

import 'is_image0_compress_stub.dart'
  if (dart.library.js) 'is_image0_compress_web.dart'
  if (dart.library.io) 'is_image0_compress.dart';

abstract class IsImageCompress {
  static IsImageCompress? _instance;

  static IsImageCompress get instance {
    return _instance ??= getImageCompress();
  }

  Future<Uint8List> compress(Uint8List bytes);
}