import 'dart:convert';

import 'package:hive/hive.dart';

import '../models/unsplash_model.dart';


class HiveDB {
  static String DB_NAME = "pinterest";
  static var box = Hive.box(DB_NAME);

  // * store
  static void storeUnsplash(List<Unsplash> unsplash) {
    List<String> stringUnsplashList = unsplash.map((e) => jsonEncode(e.toJson())).toList();
    box.put("unsplash", stringUnsplashList);
  }

  static List<Unsplash> loadUnsplash() {
    List<String> stringUnsplashList = box.get('unsplash') ?? [];
    List<Unsplash> unsplash = stringUnsplashList.map((e) => Unsplash.fromJson(jsonDecode(e))).toList();
    return unsplash;
  }

  static void removeUnsplash() {
    box.delete("unsplash");
  }

  // * store isNotDark
  static void storeIsNotDark(bool isNotDark) {
    box.put("isDark", isNotDark);
  }

  static bool loadIsNotDark() {
    return box.get("isDark") ?? true;
  }
}