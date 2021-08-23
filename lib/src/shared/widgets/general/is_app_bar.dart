
import 'package:flutter/material.dart';
import 'package:isati_integration/src/shared/widgets/general/is_icon_button.dart';
import 'package:isati_integration/utils/colors.dart';

class IsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const IsAppBar({
    Key? key, 
    this.backgroundColor = colorScaffolddWhite,
    required this.title,
    this.actions,
    this.preferredSize = const Size.fromHeight(64),
    this.showMinimifier = false,
    this.onMinimified
  }) : super(key: key);
  
  final Widget title;

  final List<Widget>? actions;

  final Color backgroundColor;

  final bool showMinimifier;
  final Function()? onMinimified;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      title: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showMinimifier && onMinimified != null) 
            SizedBox(
              width: 48,
              child: Center(
                child: IsIconButton(
                  icon: Icons.menu,
                  iconSize: 24,
                  backgroundColor: Colors.white,
                  onPressed: onMinimified,
                ),
              ),
            ),
            if (title is Text)
              Flexible(
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: title
                ),
              )
            else
              title 
        ],
      ),
      actions: actions,
    );
  }
}