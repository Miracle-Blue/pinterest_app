import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinterest_ui/pages/account_page.dart';
import 'package:pinterest_ui/pages/home_page.dart';
import 'package:pinterest_ui/pages/search_page.dart';

import '../models/topic_model.dart';
import '../models/unsplash_model.dart';
import '../services/dio_service.dart';
import 'message_page.dart';

class PageViewPage extends StatefulWidget {
  const PageViewPage({Key? key}) : super(key: key);

  static const id = "/page_view_page";

  @override
  _PageViewPageState createState() => _PageViewPageState();
}

class _PageViewPageState extends State<PageViewPage> {
  final _controller = PageController(initialPage: 0);
  List<bool> selectedItem = [true, false, false, false];

  final ValueNotifier value = ValueNotifier(0);

  bool isConnectedInNet = false;

  void _apiGetUnsplashTopicLiveTV() {
    DioNetwork.GET(DioNetwork.API_UNSPLASH_TOPIC, DioNetwork.paramsUnsplashTopic(3))
        .then((response) {
      if (response != null) {
        setState(() {
          lifeTVTopics.addAll(DioNetwork.parseTopicUnsplash(response));
        });
      }
    });
  }

  void _apiGetUnsplashTopic() {
    DioNetwork.GET(DioNetwork.API_UNSPLASH_TOPIC, DioNetwork.paramsUnsplashTopic(5))
        .then((response) {
      if (response != null) {
        setState(() {
          topics.addAll(DioNetwork.parseTopicUnsplash(response));
        });
      }
    });
  }

  // static void netConnection() async {
  //   try {
  //     final result = await InternetAddress.lookup('example.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       print('connected');
  //       isConnectedInNet = true;
  //       _apiGetUnsplashTopic();
  //       _apiGetUnsplashTopicLiveTV();
  //     }
  //   } on SocketException catch (_) {
  //     print('not connected');
  //     isConnectedInNet = false;
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetUnsplashTopic();
    _apiGetUnsplashTopicLiveTV();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
                HomePage(value: value),
                const SearchPage(),
                const MessagePage(),
                const AccountPage(),
              ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 55,
        width: MediaQuery.of(context).size.width * 0.65,
        margin: const EdgeInsets.only(bottom: 21),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              offset: const Offset(0, 0.5),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              splashRadius: 18,
              onPressed: () {
                setState(() {
                  _controller.jumpToPage(0);
                  selectedItem = [true, false, false, false];
                });
              },
              icon: Icon(
                CupertinoIcons.house,
                color: selectedItem[0] ? Colors.black : Colors.grey,
              ),
            ),
            IconButton(
              splashRadius: 18,
              onPressed: () {
                setState(() {
                  _controller.jumpToPage(1);
                  selectedItem = [false, true, false, false];
                });
              },
              icon: Icon(
                CupertinoIcons.search,
                color: selectedItem[1] ? Colors.black : Colors.grey,
              ),
            ),
            IconButton(
              splashRadius: 18,
              onPressed: () {
                setState(() {
                  _controller.jumpToPage(2);
                  selectedItem = [false, false, true, false];
                });
              },
              icon: Icon(
                CupertinoIcons.chat_bubble,
                color: selectedItem[2] ? Colors.black : Colors.grey,
              ),
            ),
            IconButton(
              splashRadius: 18,
              onPressed: () {
                setState(() {
                  _controller.jumpToPage(3);
                  selectedItem = [false, false, false, true];
                });
              },
              icon: Container(
                padding: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedItem[3] ? Colors.black : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ValueListenableBuilder(
                    builder: (BuildContext context, value, Widget? child) {
                      return CachedNetworkImage(
                        imageUrl: unsplashList.isNotEmpty
                            ? unsplashList[0].user!.profileImage!.large!
                            : '',
                        placeholder: (context, url) => Container(
                          color: Colors.black,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      );
                    },
                    valueListenable: value,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
