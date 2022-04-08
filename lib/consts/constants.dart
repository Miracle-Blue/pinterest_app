import 'dart:io';

import 'package:flutter/material.dart';

Map<String, String> popularItems = {
  'assets/images/img_1.png': 'White background',
  'assets/images/img_2.png': 'Green wallpaper',
  'assets/images/img_3.png': 'Modern kitchen design',
  'assets/images/img_4.png': 'Crockpot recipes',
};

Map<String, String> shareIcons = {
  'assets/icons/img.png': 'Send',
  'assets/icons/facebook.png': 'Facebook',
  'assets/icons/whatsapp.png': 'WhatsApp',
  'assets/icons/gmail.png': 'Gmail',
  'assets/icons/img_2.png': 'Messaging',
  'assets/icons/link.png': 'Copy link',
  'assets/icons/more-horiz.png': 'More',
};

List<String> categories = [
  'For you',
  'Today',
  'Following',
  'Health',
  'Recipes'
];


int selectedItemIndex = 0;

Connected connect = Connected();

class Connected extends ChangeNotifier {
  static bool isConnectedInNet = false;


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
