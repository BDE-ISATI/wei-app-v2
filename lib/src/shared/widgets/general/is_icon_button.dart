import 'package:flutter/material.dart';
import 'package:isati_integration/utils/colors.dart';

class IsIconButton extends StatelessWidget {
  const IsIconButton({
    Key? key,
    required this.icon,
    required this.onPressed, 
    this.iconSize = 16,
    this.backgroundColor = const Color(0xffebeced)
  }) : super(key: key);

  final IconData icon;
  final Function()? onPressed;

  final double iconSize;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: backgroundColor,
        child: InkWell(
          splashColor: darkenColor(backgroundColor),
          onTap: onPressed,
          child: SizedBox(
            width: iconSize + 16,
            height: iconSize + 16,
            child: Icon(
              icon, 
              size: iconSize,
              color: colorIsDark(backgroundColor) ? Colors.white : colorBlack,
            ),
          ),
        ),
      ),
    );
  }
}