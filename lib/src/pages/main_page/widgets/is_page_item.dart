import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isati_integration/models/page_item.dart';
import 'package:isati_integration/utils/colors.dart';

// This is the widget shown in the menu drawer
class IsPageItem extends StatelessWidget {
  const IsPageItem({
    Key? key, 
    required this.item,
    this.isActive = false,
    this.isMinimifed = false,
  }) : super(key: key);

  final PageItem item;

  final bool isActive;
  final bool isMinimifed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: isActive ? brightenColor(colorPrimary, percent: 85) : colorScaffolddWhite,
        border: !isActive ? null : Border(
          left: BorderSide(width: 4, color: colorPrimary)
        )
      ),
      child: DefaultTextStyle(
        style: TextStyle(color: isActive ? colorPrimary : colorBlack, fontWeight: FontWeight.bold),
        child: Row(
          children: [
            Expanded(
              child: Icon(item.icon, size: 20, color: isActive ? colorPrimary : colorBlack),
            ),
            // We don't show the text when it's minimified
            if (!isMinimifed) 
              Expanded(
                flex: 8,
                child: Text(item.title),
              )
          ], 
        ),
      ),
    );
  }
}