import 'package:flutter/material.dart';

import 'provider/app_provider.dart';
import 'provider/ui_providers/detail_provider.dart';
import 'provider/ui_providers/home_provider.dart';
import 'provider/ui_providers/page_view_provider.dart';
import 'provider/ui_providers/search_provider.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'services/hive_service.dart';

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(HiveDB.DB_NAME);
}

/// * Providers
final appProvider = AppProvider();
final pageViewProvider = PageViewProvider();
final homeProvider = HomeProvider();
final searchProvider = SearchProvider();
final detailProvider = DetailProvider();
