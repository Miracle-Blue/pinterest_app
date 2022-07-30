import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_app/core/extensions.dart';
import 'package:pinterest_app/injection.dart';
import 'package:pinterest_app/models/unsplash_model.dart';
import 'package:pinterest_app/provider/provider.dart';
import 'package:pinterest_app/provider/ui_providers/detail_provider.dart';
import 'package:pinterest_app/ui/widgets/grid_item.dart';

class DetailPage extends StatelessWidget {
  static int? unsplashIndex;
  static String? searchItem;
  static List<Unsplash>? soonUnsplashList;

  static const id = '/detail_page';

  const DetailPage({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      model: detailProvider,
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detail = context.watch<DetailProvider>()!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              physics: const BouncingScrollPhysics(),
              controller: detail.scrollController,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(21),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: DetailPage.soonUnsplashList![DetailPage.unsplashIndex!]
                            .urls!.regular!,
                        placeholder: (context, url) => AspectRatio(
                          aspectRatio: (DetailPage
                                  .soonUnsplashList![DetailPage.unsplashIndex!]
                                  .width! /
                              DetailPage.soonUnsplashList![DetailPage.unsplashIndex!]
                                  .height!),
                          child: Container(
                            color: DetailPage
                                .soonUnsplashList![DetailPage.unsplashIndex!].color!
                                .toColor(),
                          ),
                        ),
                        errorWidget: (context, url, error) => AspectRatio(
                          aspectRatio: (DetailPage
                                  .soonUnsplashList![DetailPage.unsplashIndex!]
                                  .width! /
                              DetailPage.soonUnsplashList![DetailPage.unsplashIndex!]
                                  .height!),
                          child: const Icon(Icons.error),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.white,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: CircleAvatar(
                                      radius: 25,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            DetailPage.soonUnsplashList!.isNotEmpty
                                                ? DetailPage
                                                    .soonUnsplashList![
                                                        DetailPage.unsplashIndex!]
                                                    .user!
                                                    .profileImage!
                                                    .large!
                                                : '',
                                        placeholder: (context, url) =>
                                            Container(
                                          color: Colors.black,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DetailPage
                                              .soonUnsplashList![
                                                  DetailPage.unsplashIndex!]
                                              .user!
                                              .name!,
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
                            ),
                            const SizedBox(height: 10),
                            Text(
                              DetailPage.soonUnsplashList![DetailPage.unsplashIndex!]
                                      .description ??
                                  '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              DetailPage.soonUnsplashList![DetailPage.unsplashIndex!]
                                      .altDescription ??
                                  '',
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
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                const ShareItem(),
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
                          itemCount: DetailPage.soonUnsplashList!.length,
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                          itemBuilder: (context, index) {
                            return GridItem(
                              unsplash: DetailPage.soonUnsplashList![index],
                              type: Type.detail,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
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
                    },
                    child: const Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShareItem extends StatelessWidget {
  const ShareItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      DetailPage.soonUnsplashList![0].user!.profileImage!.large!,
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
}
