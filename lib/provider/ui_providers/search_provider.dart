import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinterest_app/models/unsplash_model.dart';
import 'package:pinterest_app/services/dio_service.dart';
import 'package:pinterest_app/ui/widgets/bottom_sheet_content.dart';

class SearchProvider extends ChangeNotifier {
  final controller = PageController();
  final scrollController = ScrollController();
  final textController = TextEditingController();

  int countedSliverItem = 0;
  bool isLoading = false;

  List<Unsplash> searchedList = [];

  FocusNode focusNode = FocusNode();
  Timer? timer;

  int page = 1;
  String searchText = '';
  int count = 0;

  SearchProvider() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _apiGetUnsplash();
      }
    });

    focusNode.addListener(() {
      notifyListeners();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => changePage());
  }

  void changePage() async {
    Future.delayed(const Duration(seconds: 2)).then((_) {
      int? page = controller.page?.round();
      int nextPage = countedSliverItem;

      if (page != null) {
        nextPage = page + 1;
      }

      if (nextPage == 4) {
        nextPage = 0;
      }
      countedSliverItem = nextPage;
      notifyListeners();

      controller
          .animateToPage(
            nextPage,
            duration: const Duration(seconds: 1),
            curve: Curves.easeIn,
          )
          .then((_) => changePage());
    });
  }

  Future<bool> onWillPop() async {
    if (focusNode.hasFocus) {
      searchText = '';
      searchedList = [];
      textController.clear();
      focusNode.unfocus();
      notifyListeners();
      return false;
    } else if (searchText.isNotEmpty) {
      searchText = '';
      searchedList = [];
      textController.clear();
      focusNode.unfocus();
      notifyListeners();
      return false;
    } else {
      return true;
    }
  }

  void cancelButton() {
    searchText = '';
    searchedList = [];
    textController.clear();
    focusNode.unfocus();
    notifyListeners();
  }

  void editingCompleted() {
    searchedList = [];
    if (textController.text.isNotEmpty) {
      searchText = textController.text;
      focusNode.unfocus();
      _apiGetUnsplash();
    } else {
      searchText = '';
      focusNode.unfocus();
    }
    notifyListeners();
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
    isLoading = true;
    notifyListeners();

    if (page * 10 < 450) {
      Network.GET(
        Network.API_UNSPLASH_SEARCH,
        Network.paramsUnsplashSearchPage(searchText, page, 10),
      ).then((response) {
        if (response != null) {
          searchedList.addAll(
            Network.parseSearchUnsplash(response),
          );
          page++;
          isLoading = false;
          notifyListeners();
        }
      });
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    controller.dispose();
    focusNode.dispose();
    timer?.cancel();
    super.dispose();
  }
}
