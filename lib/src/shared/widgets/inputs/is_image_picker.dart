import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:isati_integration/src/shared/widgets/general/is_icon_button.dart';
import 'package:isati_integration/utils/colors.dart';

class IsImagePicker extends StatefulWidget {
  const IsImagePicker({
    Key? key, 
    this.initialImage,
    this.onUpdated
  }) : super(key: key);

  final MemoryImage? initialImage;

  final Function(String)? onUpdated;

  @override
  _IsImagePickerState createState() => _IsImagePickerState();
}

class _IsImagePickerState extends State<IsImagePicker> {
  MemoryImage? _image;

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
          Positioned.fill(
            child: _image != null ?
              Image(image: _image!, fit: BoxFit.cover,) :
              Container(
                color: colorPrimary,
                padding: const EdgeInsets.all(20),
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
        ],
      ),
    );
  }

  Future _selectImage() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image
    );

    if(result != null) {
      final bytes = result.files.first.bytes;

      if (bytes == null) {
        return;
      }

      setState(() {
        _image = MemoryImage(bytes);
      });

      if (widget.onUpdated != null) {
        widget.onUpdated!(base64Encode(bytes));
      }
    } 
  }
}