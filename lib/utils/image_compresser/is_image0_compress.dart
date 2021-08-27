import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:isati_integration/utils/image_compresser/is_image_compress.dart';

class IsImage0Compress extends IsImageCompress {
  @override
  Future<Uint8List> compress(Uint8List bytes) async {
    final result = await FlutterImageCompress.compressWithList(
      bytes,
      quality: 50
    );

    return result;
  }
}

IsImageCompress getImageCompress() => IsImage0Compress();