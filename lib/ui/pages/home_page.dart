import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_app/core/constants.dart';
import 'package:pinterest_app/injection.dart';
import 'package:pinterest_app/models/unsplash_model.dart';
import 'package:pinterest_app/provider/provider.dart';
import 'package:pinterest_app/provider/ui_providers/home_provider.dart';
import 'package:pinterest_app/ui/widgets/grid_item.dart';

class HomePage extends StatelessWidget {
  final ValueNotifier value;
  static const id = "/home_page";

  const HomePage({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      model: homeProvider,
      child: const _View(),
    );
  }
}

class _View extends StatefulWidget {
  const _View({Key? key}) : super(key: key);

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final home = context.watch<HomeProvider>()!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) => CategoryItem(
                  index: index,
                ),
              ),
            ),
            unsplashList.isNotEmpty
                ? ValueListenableBuilder(
                    valueListenable: home.notifier,
                    builder: (BuildContext context, value, Widget? child) {
                      return Expanded(
                        child: MasonryGridView.count(
                          controller: home.scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          itemCount: unsplashList.length,
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          itemBuilder: (context, index) {
                            return GridItem(
                              unsplash: unsplashList[index],
                              type: Type.home,
                            );
                          },
                        ),
                      );
                    },
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 2 - 100,
                      ),
                      const CircularProgressIndicator.adaptive(),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CategoryItem extends StatelessWidget {
  final int index;

  const CategoryItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final home = context.read<HomeProvider>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ChoiceChip(
        backgroundColor: Colors.white,
        selectedColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
        label: Text(
          categories[index],
          style: TextStyle(
            color: home.selectItem[index] ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
        onSelected: (value) => home.onSelected(value, index),
        selected: home.selectItem[index],
      ),
    );
  }
}
