import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinterest_app/injection.dart';
import 'package:pinterest_app/provider/provider.dart';
import 'package:pinterest_app/provider/ui_providers/page_view_provider.dart';
import 'package:pinterest_app/ui/pages/home_page.dart';
import 'package:pinterest_app/ui/pages/search_page.dart';

class PageViewPage extends StatelessWidget {
  static const id = "/page_view_page";

  const PageViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      model: pageViewProvider,
      child: _View(),
    );
  }
}

class _View extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pvProvider = context.watch<PageViewProvider>()!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade300,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pvProvider.controller,
        children: [
          HomePage(value: pvProvider.value),
          const SearchPage(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 60,
        width: MediaQuery.of(context).size.width * 0.45,
        margin: const EdgeInsets.only(bottom: 21),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              splashRadius: 18,
              onPressed: pvProvider.home,
              icon: Icon(
                CupertinoIcons.house,
                color: pvProvider.selectedItem[0] ? Colors.black : Colors.grey,
              ),
            ),
            IconButton(
              splashRadius: 18,
              onPressed: pvProvider.search,
              icon: Icon(
                CupertinoIcons.search,
                color: pvProvider.selectedItem[1] ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
