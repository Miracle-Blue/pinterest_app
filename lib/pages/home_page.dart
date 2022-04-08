import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_ui/models/unsplash_model.dart';
import 'package:pinterest_ui/services/dio_service.dart';

import '../consts/constants.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.value}) : super(key: key);

  static const id = "/home_page";
  final ValueNotifier value;

  @override
  _HomePageState createState() => _HomePageState();
}

extension ColorExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int selectedIndexBottom = 1;
  List<bool> selectItem = [true, false, false, false, false];

  final _scrollController = ScrollController();
  final ValueNotifier notifier = ValueNotifier(0);

  void bottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.52,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                    ),
                    const Text('Share to'),
                  ],
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: shareIcons.length,
                    itemBuilder: (context, index) => shareElement(index),
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Download image',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Hide Pin',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text.rich(
                    TextSpan(children: [
                      TextSpan(text: 'Report Pin\n'),
                      TextSpan(
                          text:
                              "This goes against Pinterest's community guidelines",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400))
                    ]),
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                const Center(
                    child: Text(
                  'This Pin is inspired by your recent activity',
                  style: TextStyle(),
                ))
              ],
            ),
          );
        });
  }

  int page = 1;

  // void _apiGetUnsplash([String searchItem = '']) {
  //   if (page * 10 < 450) {
  //     Network.GET(
  //       Network.API_UNSPLASH_SEARCH,
  //       Network.paramsUnsplashSearchPage(searchItem, page, 20),
  //     ).then((response) {
  //       if (response != null) {
  //         unsplashList.addAll(Network.parseSearchUnsplash(response));
  //         page++;
  //         setState(() {});
  //       } else {
  //
  //       }
  //     });
  //   }
  // }

  void _apiGetUnsplash([String searchItem = '']) {
    if (page * 10 < 450) {
      DioNetwork.GET(
        DioNetwork.API_UNSPLASH_SEARCH,
        DioNetwork.paramsUnsplashSearchPage(searchItem, page, 20),
      ).then((response) {
        if (response != null) {
          unsplashList.addAll(DioNetwork.parseSearchUnsplash(response));
          page++;
          setState(() {});
        } else {}
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _apiGetUnsplash(categories[selectedItemIndex]);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _apiGetUnsplash(categories[selectedItemIndex]);
      }
    });
    notifier.addListener(() {
      setState(() {
        page = 1;
        unsplashList.clear();
        _apiGetUnsplash(categories[selectedItemIndex]);
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                itemBuilder: (context, index) => categoryItem(index),
              ),
            ),
            unsplashList.isNotEmpty
                ? ValueListenableBuilder(
                    valueListenable: notifier,
                    builder: (BuildContext context, value, Widget? child) {
                      return Expanded(
                        child: MasonryGridView.count(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          itemCount: unsplashList.length,
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          itemBuilder: (context, index) {
                            return gridItem(unsplashList[index]);
                          },
                        ),
                      );
                    })
                : Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 2 - 100),
                      const CircularProgressIndicator.adaptive(),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget categoryItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ChoiceChip(
        backgroundColor: Colors.white,
        selectedColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
        label: Text(
          categories[index],
          style: TextStyle(
            color: selectItem[index] ? Colors.white : Colors.black,
            fontSize: 14,
          ),
        ),
        onSelected: (bool value) {
          setState(() {
            for (int i = 0; i < selectItem.length; i++) {
              if (i == index) {
                selectItem[i] = true;
                selectedItemIndex = index;
                notifier.value++;
              } else {
                selectItem[i] = false;
              }
            }
          });
        },
        selected: selectItem[index],
      ),
    );
  }

  Widget gridItem(Unsplash unsplash) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
                unsplashIndex: unsplashList.indexOf(unsplash),
                soonUnsplashList: unsplashList,
                searchItem: categories[selectedItemIndex]),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
        width: double.infinity,
        child: Column(
          children: [
            // ! Image
            ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: CachedNetworkImage(
                imageUrl: unsplash.urls!.regular!,
                placeholder: (context, url) => AspectRatio(
                  aspectRatio: (unsplash.width! / unsplash.height!),
                  child: Container(
                    color: unsplash.color!.toColor(),
                  ),
                ),
                errorWidget: (context, url, error) => AspectRatio(
                  aspectRatio: (unsplash.width! / unsplash.height!),
                  child: const Icon(Icons.error),
                ),
              ),
            ),
            // ! Content
            itemBottomContent(unsplash),
          ],
        ),
      ),
    );
  }

  Widget itemBottomContent(Unsplash unsplash) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        unsplash.user!.acceptedTos!
            ? circleAvatarOrDescription(unsplash)
            : favouriteIconOrEmpty(unsplash),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () => bottomSheet(),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.more_horiz,
                color: Colors.black,
                size: 18,
              ),
            ),
          ),
        )
      ],
    );
  }

  SizedBox shareElement(int index) {
    return SizedBox(
      height: 100,
      width: 70,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: index == 3 ? Colors.white : Colors.grey.shade200,
              child: Image.asset(
                shareIcons.keys.toList()[index],
                height: (index != 5 && index != 6) ? 60 : 40,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            shareIcons.values.toList()[index],
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget circleAvatarOrDescription(Unsplash unsplash) {
    return (unsplash.description != null)
        ? Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 3.0, left: 5),
              child: Text(
                unsplash.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 3.0, left: 5),
            child: CircleAvatar(
              radius: 16,
              backgroundImage:
                  NetworkImage(unsplash.user!.profileImage!.large!),
            ),
          );
  }

  Widget favouriteIconOrEmpty(Unsplash unsplash) {
    return (unsplash.user!.totalLikes! != 0)
        ? Padding(
            padding: const EdgeInsets.only(top: 3.0, left: 5),
            child: Row(
              children: [
                const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
                Text(unsplash.user!.totalLikes.toString())
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
