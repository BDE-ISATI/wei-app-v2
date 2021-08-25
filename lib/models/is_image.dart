import 'package:flutter/cupertino.dart';
import 'package:isati_integration/services/images_service.dart';

class IsImage {
  final String source;
  MemoryImage? image;

  IsImage(this.source,{
    this.image
  });
  
  Future<ImageProvider<dynamic>?> loadImageFromSource(String authorization) async {
    if (image != null) {
      return image;
    }

    final bytes = await ImagesService.instance.downloadImage(authorization, source);

    if (bytes != null) {
      image = MemoryImage(bytes);
    }

    return image;
  }
}