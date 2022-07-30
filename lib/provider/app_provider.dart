import 'dart:io';

import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  bool isConnectedInNet = false;

  AppProvider() {
    netConnection();
  }

  void netConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // print('connected');
        isConnectedInNet = true;
      }
    } on SocketException catch (_) {
      // print('not connected');
      isConnectedInNet = false;
    }
    notifyListeners();
  }
}