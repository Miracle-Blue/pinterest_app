import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_app/core/constants.dart';
import 'package:pinterest_app/core/extensions.dart';
import 'package:pinterest_app/injection.dart';
import 'package:pinterest_app/models/topic_model.dart';
import 'package:pinterest_app/provider/provider.dart';
import 'package:pinterest_app/provider/ui_providers/search_provider.dart';
import 'package:pinterest_app/ui/widgets/grid_item.dart';

class SearchPage extends StatelessWidget {
  static const id = '/search_page';

  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      model: searchProvider,
      child: const _View(),
    );
  }
}

class _View extends StatefulWidget {
  const _View({Key? key}) : super(key: key);

  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<_View>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchProvider>()!;

    super.build(context);
    return WillPopScope(
      onWillPop: search.onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            (search.focusNode.hasFocus || search.searchText.isNotEmpty)
                ? Column(
                    children: [
                      Container(height: 100, color: Colors.white),
                      search.searchedList.isNotEmpty
                          ? Expanded(
                              child: MasonryGridView.count(
                                controller: search.scrollController,
                                physics: const BouncingScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                itemCount: search.searchedList.length,
                                crossAxisCount: 2,
                                mainAxisSpacing: 2,
                                crossAxisSpacing: 2,
                                itemBuilder: (context, index) {
                                  return GridItem(
                                    unsplash: search.searchedList[index],
                                    type: Type.search,
                                  );
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
                                ? sliverPageView(search)
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
            (search.focusNode.hasFocus || search.searchText.isNotEmpty)
                ? Container(
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(top: 47.0),
                    child: TextButton(
                      onPressed: search.cancelButton,
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            search.isLoading
                ? Container(
                    alignment: Alignment.center,
                    color: Colors.grey.withOpacity(0.5),
                    child: const CircularProgressIndicator.adaptive(),
                  )
                : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: AnimatedContainer(
                width:
                    (search.focusNode.hasFocus || search.searchText.isNotEmpty)
                        ? MediaQuery.of(context).size.width - 100
                        : MediaQuery.of(context).size.width - 20,
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                ),
                duration: const Duration(milliseconds: 300),
                child: TextFormField(
                  focusNode: search.focusNode,
                  controller: search.textController,
                  textAlignVertical: TextAlignVertical.center,
                  onEditingComplete: search.editingCompleted,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: 'Search for ideas',
                    border: InputBorder.none,
                    isCollapsed: false,
                    prefixIcon: (search.focusNode.hasFocus ||
                            search.searchText.isNotEmpty)
                        ? const SizedBox.shrink()
                        : const Icon(
                            CupertinoIcons.search,
                            color: Colors.black,
                          ),
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

  Widget sliverPageView(SearchProvider search) {
    return Stack(
      children: [
        PageView.builder(
          itemCount: 4,
          controller: search.controller,
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
            children:
                [0, 1, 2, 3].map((e) => circleSliverIndex(e, search)).toList(),
          ),
        ),
      ],
    );
  }

  Container circleSliverIndex(int e, SearchProvider search) {
    return Container(
      padding: const EdgeInsets.only(left: 7),
      child: CircleAvatar(
        radius: 5,
        backgroundColor: search.countedSliverItem == e
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

  @override
  bool get wantKeepAlive => true;
}
