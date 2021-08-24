import 'package:flutter/material.dart';

class IsCard extends StatelessWidget {
  const IsCard({
    Key? key, 
    this.height, 
    this.width, 
    this.margin = EdgeInsets.zero,
    this.padding = const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),  
    required this.child,
    this.borderColor,
  }) : super(key: key);

  final Widget child;

  final double? height;
  final double? width;

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: borderColor != null ? Border.all(
          color: borderColor!,
        ) : null,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 10.0),
            blurRadius: 15.0,
            spreadRadius: -5.0
          )
        ],
      ),
      child: child,
    );
  }
}