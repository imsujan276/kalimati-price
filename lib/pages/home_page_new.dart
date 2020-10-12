import 'package:flutter/material.dart';
import 'package:kalimati_price/pages/english_web_view.dart';
import 'package:kalimati_price/pages/nepali_page.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:tabbar/tabbar.dart';

class HomePageNew extends StatefulWidget {
  @override
  _HomePageNewState createState() => _HomePageNewState();
}

class _HomePageNewState extends State<HomePageNew>
    with SingleTickerProviderStateMixin {
  final controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kalimati Price Today"),
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(0, 54, 140, 1),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: TabbarHeader(
            controller: controller,
            backgroundColor: Color.fromRGBO(0, 54, 140, 1),
            indicatorColor: Colors.red,
            foregroundColor: Colors.white70,
            tabs: [
              Tab(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: Text(
                      'दैनिक थोक मूल्य',
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: Text(
                      'Daily Wholesale Price',
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(
                Icons.help,
                color: Colors.white,
              ),
              onPressed: () => showBottomSheetModal())
        ],
      ),
      body: TabbarContent(
        controller: controller,
        children: <Widget>[
          NepaliVegPrice(),
          EnglishWebViewNew(),
        ],
      ),
    );
  }

  showBottomSheetModal() {
    showRoundedModalBottomSheet(
      context: context,
      radius: 10.0, // This is the default
      color: Colors.white, // Also default
      builder: (context) => Container(
          child: Container(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Text('About App',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  )),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Kalimati Price is the app made to know the todays's price of Kalimati.",
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "The prices are updated daily. So, no need to wait for the price update from news.",
                style: TextStyle(fontSize: 16.0),
              )
            ],
          ),
        ),
      )),
    );
  }
}
