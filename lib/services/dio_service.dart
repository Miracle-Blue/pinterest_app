import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/topic_model.dart';
import '../models/unsplash_model.dart';

import '../models/collection_model.dart';

class Network {
  static bool isTester = true;

  static const SERVER_DEVELOPMENT = "https://api.unsplash.com";
  static const SERVER_DEPLOYMENT = "https://api.unsplash.com";

  static Dio dio = Dio(
    BaseOptions(
      baseUrl: getServer(),
      headers: getHeaders(),
      connectTimeout: 10000,
      receiveTimeout: 10000,
    ),
  );

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
  static Future<String?> GET(String api, Map<String, dynamic> params) async {
    try {
      Response response = await dio.get(api, queryParameters: params);
      if (response.statusCode == 200) {
        return jsonEncode(response.data);
      }
      return null;
    } on DioError catch (e) {
      return jsonEncode(e.response!.data);
    }
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

  static Map<String, String> paramsUnsplashSearchPage(String word, int page,
      [int perPage = 6]) {
    Map<String, String> params = {
      'query': word,
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    return params;
  }

  // ! Http Parsing
  static List<Unsplash> parseUnsplash(String body) => unsplashFromJson(body);

  static List<Unsplash> parseSearchUnsplash(String body) => unsplashFromJson(
        jsonEncode(jsonDecode(body)['results']),
      );

  static List<Topic> parseTopicUnsplash(String body) => topicFromJson(body);

  static List<Collections> parseCollectionsUnsplash(String body) =>
      collectionFromJson(body);
}
