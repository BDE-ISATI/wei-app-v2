
import 'package:flutter/material.dart';
import 'package:isati_integration/utils/colors.dart';

enum IsButtonType { primary, secondary }

class IsButton extends StatelessWidget {
  const IsButton({
    Key? key, 
    required this.text, 
    this.onPressed,
    this.buttonType = IsButtonType.primary
  }) : super(key: key);
  
  final String text;

  final Function()? onPressed;

  final IsButtonType buttonType;

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0)
      ),
      primary: colorPrimary,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 22)
    );

    if (buttonType == IsButtonType.secondary) {
      buttonStyle = ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: colorPrimary)
        ),
        primary: Theme.of(context).scaffoldBackgroundColor,
        onPrimary: colorPrimary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 22)
      );
    }

    return ElevatedButton(
      style: buttonStyle,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}