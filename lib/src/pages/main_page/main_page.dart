import 'package:flutter/material.dart';
import 'package:isati_integration/models/page_item.dart';
import 'package:isati_integration/src/pages/main_page/widgets/is_menu_drawer.dart';
import 'package:isati_integration/src/shared/widgets/general/is_app_bar.dart';
import 'package:isati_integration/utils/app_manager.dart';


class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
    required this.pageItems,
    required this.pages
  }) : assert(pageItems.length == pages.length, "You don't have the same pageItems number than the pages number"), super(key: key);

  final List<PageItem> pageItems;
  final List<Widget> pages;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 1;

  bool _isMenuBarMinimified = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // show confirmation
        return (await AppManager.instance.showCloseAppConfirmation(context)) ?? false;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          const double withForShowedDrawer = 732;

          return Row(
            children: [
              if (constraints.maxWidth > withForShowedDrawer) 
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _isMenuBarMinimified ? 68 : 300,
                  child: IsMenuDrawer(
                    pageItems: widget.pageItems,
                    currentPageIndex: _currentIndex,
                    onSelectedPage: _selectedPage,
                    shouldPop: false,
                    isMinimified: _isMenuBarMinimified,
                  ),
                ),

              Expanded(
                child: Scaffold(
                  appBar: IsAppBar(
                    title: Text(widget.pageItems[_currentIndex].title),
                    showMinimifier: constraints.maxWidth > withForShowedDrawer,
                    onMinimified: () {
                      setState(() {
                        _isMenuBarMinimified = !_isMenuBarMinimified;
                      });
                    },
                  ),
                  drawer: (constraints.maxWidth <= withForShowedDrawer) 
                  ? IsMenuDrawer(
                    pageItems: widget.pageItems,
                    currentPageIndex: _currentIndex,
                    onSelectedPage: _selectedPage,
                    shouldPop: true,
                  )
                  : null,
                  body: widget.pages[_currentIndex],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future _selectedPage(PageItem pageItem) async {
    // TODO: temp workaround for provider dispose issue
    AppManager.instance.popToFirstRoute(context);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    setState(() {
      _currentIndex = pageItem.index;
    });
  }
}