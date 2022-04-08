import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/collection_model.dart';
import '../models/topic_model.dart';
import '../models/unsplash_model.dart';
import 'log_service.dart';

class DioNetwork {
  static bool isTester = true;

  static String SERVER_DEVELOPMENT = "https://api.unsplash.com";
  static String SERVER_DEPLOYMENT = "https://api.unsplash.com";

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_DEPLOYMENT;
  }

  // ! Http Headers
  static Map<String, String> getHeaders() {
    Map<String, String> headers = {
      'Accept-Version': 'v1',
      'Authorization': 'Client-ID ehGUuGYiV3wU63KvERO_F70sqvtFx-wjDu-VgJM__8Q'
    };
    return headers;
  }

  // ! Http Requests
  static Future<String?> GET(String api, Map<String, String>? params) async {
    var options = BaseOptions(
      baseUrl: getServer(),
      headers: getHeaders(),
      connectTimeout: 10000,
      receiveTimeout: 3000,
    );
    Response response = await Dio(options).get(api, queryParameters: params);
    Log.d(jsonEncode(response.data));
    if (response.statusCode == 200) return jsonEncode(response.data);
    return null;
  }

  static Future<String?> POST(String api, ) async {

  }

  // ! Http APIs
  static String API_UNSPLASH_GET = '/photos';
  static String API_UNSPLASH_SEARCH = '/search/photos';
  static String API_UNSPLASH_TOPIC = '/topics';
  static String API_UNSPLASH_COLLECTIONS = '/collections';

  // ! Http Params
  static Map<String, String> paramsEmpty() {
    Map<String, String> params = {};
    return params;
  }

  static Map<String, String> paramsUnsplashLoadPage(int page) {
    Map<String, String> params = {
      'page': page.toString(),
      'per_page': '12',
    };
    return params;
  }

  static Map<String, String> paramsUnsplashTopic(int page) {
    Map<String, String> params = {
      'page': page.toString(),
      'per_page': '4',
    };
    return params;
  }

  static Map<String, String> paramsUnsplashSearchPage(String word, int page, [int perPage = 6]) {
    Map<String, String> params = {
      'query': word,
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    return params;
  }

  // ! Http Parsing
  static List<Unsplash> parseUnsplash(String body) => unsplashFromJson(body);

  static List<Unsplash> parseSearchUnsplash(String body) =>
      unsplashFromJson(jsonEncode(jsonDecode(body)['results']));

  static List<Topic> parseTopicUnsplash(String body) => topicFromJson(body);

  static List<Collections> parseCollectionsUnsplash(String body) => collectionFromJson(body);

}