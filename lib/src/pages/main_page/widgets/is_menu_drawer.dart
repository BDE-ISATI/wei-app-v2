import 'package:flutter/material.dart';
import 'package:isati_integration/models/page_item.dart';
import 'package:isati_integration/src/pages/main_page/widgets/is_drawer_profile_info.dart';
import 'package:isati_integration/src/pages/main_page/widgets/is_page_item.dart';

class IsMenuDrawer extends StatelessWidget {
  const IsMenuDrawer({
    Key? key, 
    required this.onSelectedPage, 
    required this.shouldPop,
    required this.currentPageIndex, 
    required this.pageItems,
    this.isMinimified = false
  }) : super(key: key);

  final ValueChanged<PageItem> onSelectedPage;
  final bool shouldPop;
  final int currentPageIndex;

  final List<PageItem> pageItems;

  final bool isMinimified;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            right: BorderSide(
              color: Color(0xffedeff0)
            ),
            top: BorderSide(
              color: Color(0xffedeff0)
            ),
            bottom: BorderSide(
              color: Color(0xffedeff0)
            )
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: 98,
              child: Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  height: isMinimified ? 24 : 96,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: pageItems.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      onSelectedPage(pageItems[index]);
                      if (shouldPop) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: IsPageItem(
                      item: pageItems[index],
                      isActive: index == currentPageIndex,
                      isMinimifed: isMinimified,
                    ),
                  );
                },
              ),
            ),
            IsDrawerProfileInfo(
              isMinimified: isMinimified,
            )
          ],
        ),
      ),
    );
  }
}