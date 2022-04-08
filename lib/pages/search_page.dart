import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_ui/models/topic_model.dart';
import 'package:pinterest_ui/models/unsplash_model.dart';
import 'package:pinterest_ui/pages/home_page.dart';

import '../consts/constants.dart';
import '../services/dio_service.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  static const id = '/search_page';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final _controller = PageController();
  final _scrollController = ScrollController();
  final textController = TextEditingController();

  int countedSliverItem = 0;
  bool isLoading = false;

  List<Unsplash> searchedList = [];

  FocusNode focusNode = FocusNode();

  // void _apiUnsplashCollection() {
  //   Network.GET(Network.API_UNSPLASH_COLLECTIONS, Network.paramsEmpty())
  //       .then((response) {
  //     if (response != null) {
  //       setState(() {
  //         collection.addAll(Network.parseCollectionsUnsplash(response));
  //       });
  //     }
  //   });
  // }

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
                        )),
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
  String searchText = '';

  void _apiGetUnsplash() {
    setState(() {
      isLoading = true;
    });
    if (page * 10 < 450) {
      DioNetwork.GET(
        DioNetwork.API_UNSPLASH_SEARCH,
        DioNetwork.paramsUnsplashSearchPage(searchText, page, 10),
      ).then((response) {
        if (response != null) {
          searchedList.addAll(DioNetwork.parseSearchUnsplash(response));
          page++;
          setState(() {
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _apiGetUnsplash();
      }
    });
    focusNode.addListener(() {
      setState(() {});
    });
    Timer.periodic(
      const Duration(seconds: 4),
      (timer) {
        _controller.animateToPage(timer.tick % 4,
            duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
        setState(() {
          countedSliverItem = timer.tick % 4;
        });
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        if (focusNode.hasFocus) {
          setState(() {
            searchText = '';
            searchedList = [];
            textController.clear();
            focusNode.unfocus();
          });
          return false;
        } else if (searchText.isNotEmpty) {
          setState(() {
            searchText = '';
            searchedList = [];
            textController.clear();
            focusNode.unfocus();
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            (focusNode.hasFocus || searchText.isNotEmpty)
                ? Column(
                    children: [
                      Container(height: 100, color: Colors.white),
                      searchedList.isNotEmpty
                          ? Expanded(
                              child: MasonryGridView.count(
                                controller: _scrollController,
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                itemCount: searchedList.length,
                                crossAxisCount: 2,
                                mainAxisSpacing: 2,
                                crossAxisSpacing: 2,
                                itemBuilder: (context, index) {
                                  return gridItem(searchedList[index]);
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  )
                : NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return [
                        SliverAppBar(
                          toolbarHeight: 70,
                          elevation: 0,
                          backgroundColor: Colors.white,
                          expandedHeight: 300,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.pin,
                            background: topics.isNotEmpty
                                ? sliverPageView()
                                : Container(color: Colors.white),
                          ),
                        )
                      ];
                    },
                    body: Container(
                      color: Colors.white,
                      child: ListView(
                        children: [
                          topics.isNotEmpty
                              ? ideasElement()
                              : const SizedBox.shrink(),
                          lifeTVTopics.isNotEmpty
                              ? liveTVElement()
                              : const SizedBox.shrink(),
                          topics.isNotEmpty
                              ? shoppingSpotlight()
                              : const SizedBox.shrink(),
                          topics.isNotEmpty
                              ? popularOnPinterest()
                              : const SizedBox.shrink(),
                          const SizedBox(height: 70),
                        ],
                      ),
                    ),
                  ),
            (focusNode.hasFocus || searchText.isNotEmpty)
                ? Container(
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(top: 47.0),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          searchText = '';
                          searchedList = [];
                          textController.clear();
                          focusNode.unfocus();
                        });
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            isLoading ? Container(
              alignment: Alignment.center,
              color: Colors.grey.withOpacity(0.5),
              child: const CircularProgressIndicator.adaptive(),
            ) : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
              child: AnimatedContainer(
                width: (focusNode.hasFocus || searchText.isNotEmpty)
                    ? 310
                    : MediaQuery.of(context).size.width - 20,
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                duration: const Duration(milliseconds: 300),
                child: TextFormField(
                  focusNode: focusNode,
                  controller: textController,
                  textAlignVertical: TextAlignVertical.center,
                  onEditingComplete: () {
                    setState(() {
                      searchedList = [];
                      if (textController.text.isNotEmpty) {
                        searchText = textController.text;
                        focusNode.unfocus();
                        _apiGetUnsplash();
                      } else {
                        searchText = '';
                        focusNode.unfocus();
                      }
                    });
                  },
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: 'Search for ideas',
                    border: InputBorder.none,
                    isCollapsed: false,
                    prefixIcon: (focusNode.hasFocus || searchText.isNotEmpty)
                        ? const SizedBox.shrink()
                        : const Icon(CupertinoIcons.search,
                            color: Colors.black),
                    prefixIconConstraints: const BoxConstraints(maxWidth: 40),
                    suffixIcon: const Icon(
                      CupertinoIcons.camera,
                      color: Colors.black,
                    ),
                    suffixIconConstraints: const BoxConstraints(maxWidth: 40),
                  ),
                  cursorColor: Colors.red,
                  cursorHeight: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sliverPageView() {
    return Stack(
      children: [
        PageView.builder(
          itemCount: 4,
          controller: _controller,
          itemBuilder: (BuildContext context, int index) {
            return Image.network(
              topics[index].coverPhoto!.urls!.regular!,
              fit: BoxFit.cover,
            );
          },
        ),
        Positioned(
          top: 300,
          left: MediaQuery.of(context).size.width / 2 - 34,
          child: Row(
            children: [0, 1, 2, 3].map((e) => circleSliverIndex(e)).toList(),
          ),
        ),
      ],
    );
  }

  Container circleSliverIndex(int e) {
    return Container(
      padding: const EdgeInsets.only(left: 7),
      child: CircleAvatar(
        radius: 5,
        backgroundColor: countedSliverItem == e
            ? Colors.white
            : Colors.white.withOpacity(0.5),
      ),
    );
  }

  Widget ideasElement() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Center(
          child: Text(
            "Ideas from creators",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...topics.map((e) => ideasField(e)).toList(),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  height: 50,
                  width: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.grey.shade300,
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      minimumSize: const Size(80, 50),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "View All",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget liveTVElement() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Center(
          child: Text(
            "Live on Pinterest TV",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...lifeTVTopics.map((e) => liveTVField(e)).toList(),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  height: 50,
                  width: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.grey.shade300,
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      minimumSize: const Size(80, 50),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "View All",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget shoppingSpotlight() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                CupertinoIcons.tag_fill,
                size: 15,
              ),
              Text(
                " Shopping spotlight",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 270,
          alignment: Alignment.center,
          child: PageView(
            controller: PageController(viewportFraction: 0.9),
            children: [
              ...topics
                  .map((e) => Container(
                        padding: const EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: e.coverPhoto!.urls!.regular!,
                            placeholder: (context, url) => Container(
                              color: e.coverPhoto!.color!.toColor(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ))
                  .toList(),
              Center(
                child: MaterialButton(
                  elevation: 0,
                  color: Colors.grey.shade300,
                  onPressed: () {},
                  shape: const StadiumBorder(),
                  minWidth: 40,
                  height: 60,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget popularOnPinterest() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Center(
          child: Text(
            "Live on Pinterest TV",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Column(
              children: [
                for (int i = 0; i < 2; i++)
                  Container(
                    margin:
                        const EdgeInsets.only(left: 10, right: 5, bottom: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(popularItems.keys.toList()[i]),
                          ),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          height: 80,
                          alignment: Alignment.center,
                          color: Colors.grey.withOpacity(0.5),
                          child: Text(
                            popularItems.values.toList()[i],
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Column(
              children: [
                for (int i = 2; i < 4; i++)
                  Container(
                    margin:
                        const EdgeInsets.only(left: 5, right: 10, bottom: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(popularItems.keys.toList()[i]),
                          ),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          height: 80,
                          alignment: Alignment.center,
                          color: Colors.grey.withOpacity(0.5),
                          child: Text(
                            popularItems.values.toList()[i],
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget ideasField(Topic topic) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      child: Stack(
        children: [
          SizedBox(
            height: 230,
            width: 140,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: topic.coverPhoto!.urls!.regular!,
                placeholder: (context, url) => Container(
                  color: topic.coverPhoto!.color!.toColor(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Positioned(
            top: 204,
            left: 47,
            child: CircleAvatar(
              radius: 23,
              backgroundColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(1.5),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                        topic.owners!.first.profileImage!.large!)),
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: Container(
              width: 30,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withOpacity(0.7),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 4,
                  ),
                  const Icon(
                    CupertinoIcons.rectangle_fill_on_rectangle_fill,
                    size: 13,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(
                    topic.previewPhotos!.length.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget liveTVField(Topic topic) {
    return Container(
      padding: const EdgeInsets.only(left: 10),
      child: Stack(
        children: [
          SizedBox(
            height: 230,
            width: 140,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: topic.coverPhoto!.urls!.regular!,
                placeholder: (context, url) => Container(
                  color: topic.coverPhoto!.color!.toColor(),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Positioned(
            top: 204,
            left: 47,
            child: CircleAvatar(
              radius: 23,
              backgroundColor: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(1.5),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                        topic.owners!.first.profileImage!.large!)),
              ),
            ),
          ),
          Positioned(
            top: 5,
            left: 5,
            child: Container(
              width: 65,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black.withOpacity(0.7),
              ),
              child: Row(
                children: const [
                  SizedBox(
                    width: 4,
                  ),
                  Icon(
                    CupertinoIcons.circle_fill,
                    color: Colors.red,
                    size: 13,
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    '6 hours',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget gridItem(Unsplash unsplash) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailPage(unsplashIndex: searchedList.indexOf(unsplash), soonUnsplashList: searchedList, searchItem: searchText),
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
  bool get wantKeepAlive => true;
}
