import 'package:flutter/material.dart';
import 'package:isati_integration/utils/colors.dart';

class SubmitSoloChallengeAddButton extends StatelessWidget {
  const SubmitSoloChallengeAddButton({
    Key? key,
    required this.onPressed
  }) : super(key: key);

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: brightenColor(colorPrimary, percent: 85),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: colorPrimary
          )
        ),
        child: Center(
          child: Icon(Icons.add, size: 75, color: colorPrimary,),
        ),
      ),
    );
  }
}