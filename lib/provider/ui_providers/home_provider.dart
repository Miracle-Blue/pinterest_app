import 'package:flutter/material.dart';
import 'package:pinterest_app/core/constants.dart';
import 'package:pinterest_app/models/unsplash_model.dart';
import 'package:pinterest_app/services/dio_service.dart';
import 'package:pinterest_app/ui/widgets/bottom_sheet_content.dart';

class HomeProvider extends ChangeNotifier {
  int selectedIndexBottom = 1;
  List<bool> selectItem = [true, false, false, false, false];

  final scrollController = ScrollController();
  final ValueNotifier notifier = ValueNotifier(0);

  HomeProvider() {
    _apiGetUnsplash(categories[selectedItemIndex]);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _apiGetUnsplash(categories[selectedItemIndex]);
      }
    });
    notifier.addListener(() {
      page = 1;
      unsplashList.clear();
      _apiGetUnsplash(categories[selectedItemIndex]);
      notifyListeners();
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

  int page = 1;

  void _apiGetUnsplash([String searchItem = '']) {
    if (page * 10 < 450) {
      Network.GET(
        Network.API_UNSPLASH_SEARCH,
        Network.paramsUnsplashSearchPage(searchItem, page, 20),
      ).then((response) {
        if (response != null) {
          unsplashList.addAll(Network.parseSearchUnsplash(response));
          page++;
          notifyListeners();
        }
      });
    }
  }

  void onSelected(bool value, int index) {
      for (int i = 0; i < selectItem.length; i++) {
        if (i == index) {
          selectItem[i] = true;
          selectedItemIndex = index;
          notifier.value++;
        } else {
          selectItem[i] = false;
        }
      }
      notifyListeners();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
