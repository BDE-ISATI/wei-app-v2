import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isati_integration/src/shared/widgets/general/is_icon_button.dart';
import 'package:isati_integration/utils/colors.dart';

class SubmitSoloChallengeMediaButton extends StatelessWidget {
  const SubmitSoloChallengeMediaButton({
    Key? key, 
    required this.media,
    required this.onRemove,
  }) : super(key: key);

  final String media;

  final Function() onRemove;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              height: 200,
              child: Image.memory(
                base64Decode(media),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IsIconButton(
              backgroundColor: colorError,
              onPressed: onRemove,
              icon: Icons.remove,
            ),
          )
        ],
      )
    );
  }
}