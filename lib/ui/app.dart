import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:pinterest_app/injection.dart';
import 'package:pinterest_app/provider/app_provider.dart';
import 'package:pinterest_app/provider/provider.dart';
import 'pages/page_view.dart';
import 'pages/search_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      model: appProvider,
      child: _View(),
    );
  }
}

class _View extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>()!;

    return StreamBuilder<ConnectivityResult>(
      stream: app.stream,
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return const _Loading();
        } else if (snapshot.data == ConnectivityResult.mobile ||
            snapshot.data == ConnectivityResult.wifi) {
          return const _ConnectUI();
        } else {
          return const _NoConnectUI();
        }
      },
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pinterest',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blueGrey,
      ),
      debugShowCheckedModeBanner: false,
      home: const ColoredBox(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}

class _ConnectUI extends StatelessWidget {
  const _ConnectUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pinterest',
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
    );
  }
}

class _NoConnectUI extends StatelessWidget {
  const _NoConnectUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pinterest',
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icons/no_network.png",
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
                  "You'll see more ideas when you're back on the internet.",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
