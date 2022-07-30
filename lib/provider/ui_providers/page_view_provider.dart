import 'package:flutter/material.dart';
import 'package:pinterest_app/models/topic_model.dart';
import 'package:pinterest_app/services/dio_service.dart';

class PageViewProvider extends ChangeNotifier {
  final controller = PageController(initialPage: 0);
  List<bool> selectedItem = [true, false];

  final ValueNotifier value = ValueNotifier(0);

  bool isConnectedInNet = false;

  PageViewProvider() {
    _apiGetUnsplashTopic();
    _apiGetUnsplashTopicLiveTV();
  }

  void _apiGetUnsplashTopicLiveTV() {
    Network.GET(Network.API_UNSPLASH_TOPIC, Network.paramsUnsplashTopic(3))
        .then((response) {
      if (response != null) {
        lifeTVTopics.addAll(Network.parseTopicUnsplash(response));
        notifyListeners();
      }
    });
  }

  void _apiGetUnsplashTopic() {
    Network.GET(Network.API_UNSPLASH_TOPIC, Network.paramsUnsplashTopic(5))
        .then((response) {
      if (response != null) {
        topics.addAll(Network.parseTopicUnsplash(response));
        notifyListeners();
      }
    });
  }

  void home() {
    controller.jumpToPage(0);
    selectedItem = [true, false];
    notifyListeners();
  }

  void search() {
    controller.jumpToPage(1);
    selectedItem = [false, true];
    notifyListeners();
  }
}
