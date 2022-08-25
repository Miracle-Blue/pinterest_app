import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  late Stream<ConnectivityResult> stream = Connectivity().onConnectivityChanged
    ..listen((event) {});
}
