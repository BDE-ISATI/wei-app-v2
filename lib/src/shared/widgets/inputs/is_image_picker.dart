import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isati_integration/src/shared/widgets/general/is_icon_button.dart';
import 'package:isati_integration/utils/colors.dart';
import 'package:isati_integration/utils/image_compresser/is_image_compress.dart';

class IsImagePicker extends StatefulWidget {
  const IsImagePicker({
    Key? key, 
    this.initialImage,
    this.defaultPadding = const EdgeInsets.all(20.0),
    this.onUpdated
  }) : super(key: key);

  final MemoryImage? initialImage;

  final EdgeInsets defaultPadding;

  final Function(String)? onUpdated;

  @override
  _IsImagePickerState createState() => _IsImagePickerState();
}

class _IsImagePickerState extends State<IsImagePicker> {
  MemoryImage? _image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _image = widget.initialImage;
  }

  @override
  void didUpdateWidget(covariant IsImagePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    _image = widget.initialImage;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _selectImage,
      child: Stack(
        children: [
          if (_isLoading) 
            Positioned.fill(
              child: Container(
                color: brightenColor(colorPrimary, percent: 85),
                child: const Center(child: CircularProgressIndicator(),),
              ),
            )
          else ...{
            Positioned.fill(
              child: _image != null ?
                Image(image: _image!, fit: BoxFit.cover,) :
                Container(
                  color: colorPrimary,
                  padding: widget.defaultPadding,
                  child: Image.asset("assets/images/logo_white.png"),
                ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IsIconButton(
                  backgroundColor: colorSecondary,
                  icon: Icons.edit, 
                  onPressed: _selectImage
                ),
              ),
            )
          }
        ],
      ),
    );
  }

  Future _selectImage() async {
    setState(() {
      _isLoading = true;
    });

    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image
    );

    if(result != null) {
      Uint8List? bytes;

      if (kIsWeb) {
        bytes = result.files.single.bytes;
      }
      else {
        final File file = File(result.files.single.path!);
        bytes = await file.readAsBytes();
      }

      if (bytes == null) {
        return;
      }

      final compressed = await IsImageCompress.instance.compress(bytes);

      setState(() {
        _image = MemoryImage(compressed);
      });

      if (widget.onUpdated != null) {
        widget.onUpdated!(base64Encode(compressed));
      }
    } 

    setState(() {
      _isLoading = false;
    });
  }
}