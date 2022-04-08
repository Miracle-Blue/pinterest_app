// import 'dart:async';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:pinterest_ui/pages/home_page.dart';
// import 'package:pinterest_ui/services/log_service.dart';
//
// import '../consts/constants.dart';
// import '../models/unsplash_model.dart';
// import '../services/http_service.dart';
// import 'detail_page.dart';
//
// class BodyList extends StatefulWidget {
//   const BodyList({Key? key}) : super(key: key);
//
//   @override
//   _BodyListState createState() => _BodyListState();
// }
//
// class _BodyListState extends State<BodyList> {
//   final _scrollController = ScrollController();
//
//   void bottomSheet() {
//     showModalBottomSheet(
//         context: context,
//         builder: (context) {
//           return Container(
//             color: Colors.white,
//             padding: const EdgeInsets.all(10),
//             height: MediaQuery.of(context).size.height * 0.52,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     IconButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         icon: const Icon(
//                           Icons.clear,
//                           color: Colors.black,
//                         )),
//                     const Text('Share to'),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 100,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: shareIcons.length,
//                     itemBuilder: (context, index) => shareElement(index),
//                   ),
//                 ),
//                 const Divider(),
//                 const SizedBox(height: 10),
//                 TextButton(
//                   onPressed: () {},
//                   child: const Text(
//                     'Download image',
//                     style: TextStyle(fontSize: 20, color: Colors.black),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {},
//                   child: const Text(
//                     'Hide Pin',
//                     style: TextStyle(fontSize: 20, color: Colors.black),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {},
//                   child: const Text.rich(
//                     TextSpan(children: [
//                       TextSpan(text: 'Report Pin\n'),
//                       TextSpan(
//                           text:
//                               "This goes against Pinterest's community guidelines",
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w400))
//                     ]),
//                     style: TextStyle(fontSize: 20, color: Colors.black),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Divider(),
//                 const SizedBox(height: 10),
//                 const Center(
//                     child: Text(
//                   'This Pin is inspired by your recent activity',
//                   style: TextStyle(),
//                 ))
//               ],
//             ),
//           );
//         });
//   }
//
//   void _apiGetUnsplash([String searchItem = '']) {
//     if (page * 10 < 450) {
//       Network.GET(
//         Network.API_UNSPLASH_SEARCH,
//         Network.paramsUnsplashSearchPage(
//             searchItem, page, 10),
//       ).then((response) {
//         if (response != null) {
//           setState(() {
//             unsplashList.addAll(Network.parseSearchUnsplash(response));
//             page++;
//             if (g1Length == 0) {
//               g1.add(gridItem(unsplashList[0]));
//               g1Length +=
//                   unsplashList.first.height! / unsplashList.first.width!;
//             }
//           });
//         }
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _apiGetUnsplash();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         _apiGetUnsplash(categories[selectedItemIndex]);
//       }
//     });
//     notifier.addListener(() {
//       _apiGetUnsplash(categories[selectedItemIndex]);
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//         valueListenable: notifier,
//         builder: (BuildContext context, value, Widget? child) {
//           for (int i = unsplashLength; i < unsplashList.length; i++) {
//             if (g1Length < g2Length) {
//               g1.add(gridItem(unsplashList[i]));
//               g1Length += unsplashList[i].height! / unsplashList[i].width!;
//             } else {
//               g2.add(gridItem(unsplashList[i]));
//               g2Length += unsplashList[i].height! / unsplashList[i].width!;
//             }
//           }
//           unsplashLength = unsplashList.isNotEmpty ? unsplashList.length : 1;
//
//           return unsplashList.isNotEmpty
//               ? Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(3.0),
//                     child: ListView(
//                       controller: _scrollController,
//                       physics: const BouncingScrollPhysics(),
//                       children: [
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Expanded(
//                               child: Column(children: g1),
//                             ),
//                             Expanded(
//                               child: Column(children: g2),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               : Column(
//                   children: [
//                     SizedBox(
//                         height: MediaQuery.of(context).size.height / 2 - 100),
//                     const CircularProgressIndicator.adaptive(),
//                   ],
//                 );
//         });
//   }
//
//   Widget gridItem(Unsplash unsplash) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) =>
//                 DetailPage(unsplashIndex: unsplashList.indexOf(unsplash)),
//           ),
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
//         width: double.infinity,
//         child: Column(
//           children: [
//             // ! Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(13),
//               child: CachedNetworkImage(
//                 imageUrl: unsplash.urls!.regular!,
//                 placeholder: (context, url) => AspectRatio(
//                   aspectRatio: (unsplash.width! / unsplash.height!),
//                   child: Container(
//                     color: unsplash.color!.toColor(),
//                   ),
//                 ),
//                 errorWidget: (context, url, error) => AspectRatio(
//                   aspectRatio: (unsplash.width! / unsplash.height!),
//                   child: const Icon(Icons.error),
//                 ),
//               ),
//             ),
//             // ! Content
//             itemBottomContent(unsplash),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget itemBottomContent(Unsplash unsplash) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         unsplash.user!.acceptedTos!
//             ? circleAvatarOrDescription(unsplash)
//             : favouriteIconOrEmpty(unsplash),
//         Align(
//           alignment: Alignment.centerRight,
//           child: InkWell(
//             onTap: () => bottomSheet(),
//             child: const Padding(
//               padding: EdgeInsets.all(8.0),
//               child: Icon(
//                 Icons.more_horiz,
//                 color: Colors.black,
//                 size: 18,
//               ),
//             ),
//           ),
//         )
//       ],
//     );
//   }
//
//   SizedBox shareElement(int index) {
//     return SizedBox(
//       height: 100,
//       width: 70,
//       child: Column(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(30),
//             child: CircleAvatar(
//               radius: 30,
//               backgroundColor: index == 3 ? Colors.white : Colors.grey.shade200,
//               child: Image.asset(
//                 shareIcons.keys.toList()[index],
//                 height: (index != 5 && index != 6) ? 60 : 40,
//               ),
//             ),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             shareIcons.values.toList()[index],
//             style: const TextStyle(fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget circleAvatarOrDescription(Unsplash unsplash) {
//     return (unsplash.description != null)
//         ? Flexible(
//             child: Padding(
//               padding: const EdgeInsets.only(top: 3.0, left: 5),
//               child: Text(
//                 unsplash.description!,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style:
//                     const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
//               ),
//             ),
//           )
//         : Padding(
//             padding: const EdgeInsets.only(top: 3.0, left: 5),
//             child: CircleAvatar(
//               radius: 16,
//               backgroundImage:
//                   NetworkImage(unsplash.user!.profileImage!.large!),
//             ),
//           );
//   }
//
//   Widget favouriteIconOrEmpty(Unsplash unsplash) {
//     return (unsplash.user!.totalLikes! != 0)
//         ? Padding(
//             padding: const EdgeInsets.only(top: 3.0, left: 5),
//             child: Row(
//               children: [
//                 const Icon(
//                   Icons.favorite,
//                   color: Colors.red,
//                 ),
//                 Text(unsplash.user!.totalLikes.toString())
//               ],
//             ),
//           )
//         : const SizedBox.shrink();
//   }
// }
