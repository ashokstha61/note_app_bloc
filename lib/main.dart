import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:todo_app/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: false,
        ),
        home: HomePageScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
