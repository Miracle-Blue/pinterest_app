import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinterest_app/core/constants.dart';
import 'package:pinterest_app/core/extensions.dart';
import 'package:pinterest_app/models/unsplash_model.dart';
import 'package:pinterest_app/provider/provider.dart';
import 'package:pinterest_app/provider/ui_providers/detail_provider.dart';
import 'package:pinterest_app/provider/ui_providers/home_provider.dart';
import 'package:pinterest_app/provider/ui_providers/search_provider.dart';
import 'package:pinterest_app/ui/pages/detail_page.dart';

enum Type { home, search, detail }

class GridItem extends StatelessWidget {
  final Unsplash unsplash;
  final Type type;

  const GridItem({
    Key? key,
    required this.unsplash,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic provider;
    switch (type) {
      case Type.home:
        provider = context.read<HomeProvider>()!;
        break;
      case Type.search:
        provider = context.read<SearchProvider>()!;
        break;
      case Type.detail:
        provider = context.read<DetailProvider>()!;
        break;
    }

    return GestureDetector(
      onTap: () {
        final bool? isDetail =
            ModalRoute.of(context)?.settings.name?.contains('/detail_page');
        final bool? isSearch =
            ModalRoute.of(context)?.settings.name?.contains('/search_page');
        final doNotOpen = isDetail != null &&
            !isDetail &&
            isSearch != null &&
            !isSearch &&
            !(provider is SearchProvider && provider.searchText.isNotEmpty);

        if (doNotOpen) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              DetailPage.unsplashIndex = unsplashList.indexOf(unsplash);
              DetailPage.soonUnsplashList = unsplashList;
              DetailPage.searchItem = categories[selectedItemIndex];

              return const DetailPage();
            }),
          );
        }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (unsplash.user!.acceptedTos!)
                  if (unsplash.description != null)
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3.0, left: 5),
                        child: Text(
                          unsplash.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0, left: 5),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage:
                            NetworkImage(unsplash.user!.profileImage!.large!),
                      ),
                    )
                else if (unsplash.user!.totalLikes! != 0)
                  Padding(
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
                else
                  const SizedBox.shrink(),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () => provider.bottomSheet(context),
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
            ),
          ],
        ),
      ),
    );
  }
}
