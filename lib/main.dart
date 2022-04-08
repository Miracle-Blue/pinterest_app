import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinterest_ui/consts/constants.dart';
import 'package:pinterest_ui/pages/page_view.dart';
import 'package:pinterest_ui/pages/search_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pinterest_ui/services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(HiveDB.DB_NAME);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    connect.netConnection();
    connect.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return (Connected.isConnectedInNet)
        ? MaterialApp(
            title: 'Pinterest UI',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              primarySwatch: Colors.blueGrey,
            ),
            debugShowCheckedModeBanner: false,
            home: const PageViewPage(),
            routes: {
              SearchPage.id: (context) => const SearchPage(),
              PageViewPage.id: (context) => const PageViewPage(),
            },
          )
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Container(
                color: Colors.white,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/img_3.png",
                        height: 50,
                      ),
                      const Text(
                        "Looks like you're offline",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                          "You'll see more ideas when you're back on the internet."),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
