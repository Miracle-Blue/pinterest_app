import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_ui/models/unsplash_model.dart';
import 'package:pinterest_ui/pages/home_page.dart';
import 'package:pinterest_ui/services/hive_service.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  static const id = "/account_page";

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<Widget> g1 = [];
  double g1Length = 0;
  List<Widget> g2 = [];
  double g2Length = 0;
  List<Unsplash> unsplash = [];

  int unsplashLength = 1;

  void _loadData() {
    unsplash = HiveDB.loadUnsplash();
    if (unsplash.isNotEmpty) {
      g1.add(gridItem(unsplash[0]));
      g1Length += unsplash.first.height! / unsplash.first.width!;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    for (int i = unsplashLength; i < unsplash.length; i++) {
      if (g1Length < g2Length) {
        g1.add(gridItem(unsplash[i]));
        g1Length += unsplash[i].height! / unsplash[i].width!;
      } else {
        g2.add(gridItem(unsplash[i]));
        g2Length += unsplash[i].height! / unsplash[i].width!;
      }
    }
    unsplashLength = unsplash.isNotEmpty ? unsplash.length : 1;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              toolbarHeight: 70,
              elevation: 0,
              backgroundColor: Colors.white,
              expandedHeight: 300,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Image.asset(""),
              ),
            ),
            const SliverAppBar(
              elevation: 0,
              backgroundColor: Colors.red,
              pinned: true,
            )
          ];
        },
        body: Container(),
      ),
    );
  }

  Widget gridItem(Unsplash unsplash) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
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
        ],
      ),
    );
  }
}
