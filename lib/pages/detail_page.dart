import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_ui/models/unsplash_model.dart';
import 'package:pinterest_ui/pages/home_page.dart';

import '../consts/constants.dart';
import '../services/dio_service.dart';

class DetailPage extends StatefulWidget {
  final int unsplashIndex;
  final String searchItem;
  final List<Unsplash> soonUnsplashList;

  const DetailPage(
      {Key? key,
      required this.unsplashIndex,
      required this.soonUnsplashList,
      required this.searchItem})
      : super(key: key);

  static const id = '/detail_page';

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _scrollController = ScrollController();
  int page = 1;
  bool isLoad = true;

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

  void _apiGetUnsplash() {
    if (page * 10 < 450) {
      DioNetwork.GET(
        DioNetwork.API_UNSPLASH_SEARCH,
        DioNetwork.paramsUnsplashSearchPage(widget.searchItem, page, 10),
      ).then((response) {
        if (response != null) {
          widget.soonUnsplashList.addAll(DioNetwork.parseSearchUnsplash(response));
          page++;
          setState(() {isLoad = false;});
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _apiGetUnsplash();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          isLoad = true;
        });
        _apiGetUnsplash();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              ListView(
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                children: [
                  mainContent(),
                  const SizedBox(height: 5),
                  shareItem(),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(21),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      color: Colors.white,
                      child: Column(
                        children: [
                          const SizedBox(height: 5),
                          const Text(
                            'More like this',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          MasonryGridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            itemCount: widget.soonUnsplashList.length,
                            crossAxisCount: 2,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            itemBuilder: (context, index) {
                              return gridItem(widget.soonUnsplashList[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              _appBar(),
            ],
          ),
        ));
  }

  ClipRRect shareItem() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(21),
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 5),
            const Text(
              'Share your feedback',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey.shade300,
                    child: Image.network(
                      widget.soonUnsplashList[0].user!.profileImage!.large!,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Add a comment',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            MaterialButton(
              elevation: 0,
              shape: const StadiumBorder(),
              height: 45,
              color: Colors.grey.shade300,
              onPressed: () {},
              child: const Text("Show more"),
            ),
          ],
        ),
      ),
    );
  }

  Padding _appBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () {
              // _menuBottomSheet();
            },
            child: const Icon(
              Icons.more_horiz,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  ClipRRect mainContent() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(21),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [mainImage(), mainImageContent()],
      ),
    );
  }

  Container mainImageContent() {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 10),
          accountListTile(),
          const SizedBox(height: 10),
          Text(
            widget.soonUnsplashList[widget.unsplashIndex].description ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text(
            widget.soonUnsplashList[widget.unsplashIndex].altDescription ?? '',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.chat_bubble_fill,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      elevation: 0,
                      shape: const StadiumBorder(),
                      height: 45,
                      color: Colors.grey.shade300,
                      onPressed: () {},
                      child: const Text("Visit"),
                    ),
                    const SizedBox(width: 10),
                    MaterialButton(
                      elevation: 0,
                      shape: const StadiumBorder(),
                      height: 45,
                      color: Colors.red,
                      onPressed: () {},
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.share,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget mainImage() {
    return CachedNetworkImage(
      imageUrl: widget.soonUnsplashList[widget.unsplashIndex].urls!.regular!,
      placeholder: (context, url) => AspectRatio(
        aspectRatio: (widget.soonUnsplashList[widget.unsplashIndex].width! /
            widget.soonUnsplashList[widget.unsplashIndex].height!),
        child: Container(
          color: widget.soonUnsplashList[widget.unsplashIndex].color!.toColor(),
        ),
      ),
      errorWidget: (context, url, error) => AspectRatio(
        aspectRatio: (widget.soonUnsplashList[widget.unsplashIndex].width! /
            widget.soonUnsplashList[widget.unsplashIndex].height!),
        child: const Icon(Icons.error),
      ),
    );
  }

  Padding accountListTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: CircleAvatar(
              radius: 25,
              child: CachedNetworkImage(
                imageUrl: widget.soonUnsplashList.isNotEmpty
                    ? widget.soonUnsplashList[widget.unsplashIndex].user!
                        .profileImage!.large!
                    : '',
                placeholder: (context, url) => Container(
                  color: Colors.black,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.soonUnsplashList[widget.unsplashIndex].user!.name!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  '2.4m Followers',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          MaterialButton(
            color: Colors.grey.shade300,
            elevation: 0,
            height: 45,
            shape: const StadiumBorder(),
            onPressed: () {},
            child: const Text('Follow'),
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
            builder: (context) => DetailPage(
                unsplashIndex: widget.soonUnsplashList.indexOf(unsplash),
                soonUnsplashList: widget.soonUnsplashList,
                searchItem: widget.searchItem),
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
}
