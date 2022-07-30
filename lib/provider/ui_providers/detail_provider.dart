import 'package:flutter/material.dart';
import 'package:pinterest_app/services/dio_service.dart';
import 'package:pinterest_app/ui/pages/detail_page.dart';
import 'package:pinterest_app/ui/widgets/bottom_sheet_content.dart';

class DetailProvider extends ChangeNotifier {
  final scrollController = ScrollController();
  int page = 1;
  bool isLoad = true;

  DetailProvider() {
    _apiGetUnsplash();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        isLoad = true;
        _apiGetUnsplash();
        notifyListeners();
      }
    });
  }

  void bottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return const BottomSheetContent();
      },
    );
  }

  void _apiGetUnsplash() {
    if (page * 10 < 450) {
      Network.GET(
        Network.API_UNSPLASH_SEARCH,
        Network.paramsUnsplashSearchPage(DetailPage.searchItem!, page, 10),
      ).then((response) {
        if (response != null) {

          DetailPage.soonUnsplashList!.addAll(
            Network.parseSearchUnsplash(response),
          );

          page++;
          isLoad = false;
          notifyListeners();
        }
      });
    }
  }
}
