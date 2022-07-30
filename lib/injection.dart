import 'provider/app_provider.dart';
import 'provider/ui_providers/detail_provider.dart';
import 'provider/ui_providers/home_provider.dart';
import 'provider/ui_providers/page_view_provider.dart';
import 'provider/ui_providers/search_provider.dart';

/// ! Providers
final appProvider = AppProvider();
final pageViewProvider = PageViewProvider();
final homeProvider = HomeProvider();
final searchProvider = SearchProvider();
final detailProvider = DetailProvider();
