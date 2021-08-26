import 'package:flutter/material.dart';
import 'package:isati_integration/models/is_image.dart';
import 'package:isati_integration/src/shared/widgets/general/is_image_widget.dart';

class AdminDrawingButton extends StatelessWidget {
  const AdminDrawingButton({
    Key? key, 
    required this.media,
  }) : super(key: key);

  final IsImage media;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showDialog<void>(
          context: context,
          builder: (context) => Dialog(
            insetPadding: EdgeInsets.zero,
            child: IsImageWidget(source: media,)
          )
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          height: 200,
          child: IsImageWidget(
            source: media,
            fit: BoxFit.cover,
          ),
        )
      ),
    );
  }
}