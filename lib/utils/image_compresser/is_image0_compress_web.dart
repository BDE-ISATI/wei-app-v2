// ignore: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:isati_integration/utils/image_compresser/is_image_compress.dart';
import 'package:isati_integration/utils/js_controller.dart';



class IsImage0CompressWeb extends IsImageCompress {
  @override
  Future<Uint8List> compress(Uint8List bytes) async {
    final Completer<String> _compressionCompleter = Completer();

    final String base64data = "data:image/jpeg;base64,${base64Encode(bytes)}";

    compressAndDownloadImage(base64data);
    html.window.addEventListener(
      "message", (event) {
        if (_compressionCompleter.isCompleted) {
          return;
        }

        final html.MessageEvent event2 = event as html.MessageEvent;
        final String data = event2.data as String;

        _compressionCompleter.complete(data);
      }
    );
    
    final result = await _compressionCompleter.future;

    return base64Decode(result);
  }

}

IsImageCompress getImageCompress() => IsImage0CompressWeb();