import 'dart:convert';

import 'package:flutter/material.dart';

class ProofButton extends StatelessWidget {
  const ProofButton({
    Key? key, 
    required this.media,
  }) : super(key: key);

  final String media;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await showDialog<void>(
          context: context,
          builder: (context) => Dialog(
            insetPadding: EdgeInsets.zero,
            child: Image.memory(base64Decode(media)),
          )
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          height: 200,
          child: Image.memory(
            base64Decode(media),
            fit: BoxFit.cover,
          ),
        )
      ),
    );
  }
}