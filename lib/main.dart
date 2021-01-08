import 'package:flutter/material.dart';
import 'package:kalimati_price/pages/home_page.dart';
// import 'package:kalimati_price/pages/home_page_new.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalimati Price',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      // home: HomePageNew(),
      debugShowCheckedModeBanner: false,
    );
  }
}
