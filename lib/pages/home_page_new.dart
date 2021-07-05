import 'dart:async';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalimati_price/pages/english_web_view.dart';
import 'package:kalimati_price/pages/nepali_page.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePageNew extends StatefulWidget {
  @override
  _HomePageNewState createState() => _HomePageNewState();
}

class _HomePageNewState extends State<HomePageNew>
    with SingleTickerProviderStateMixin {
  final controller = PageController();
  bool showEnglishVersion = false;

  String appPackageName = "com.suga.kalimati_price";

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: null,
    keywords: <String>[
      'nepal',
      'vegetables',
      'kalimati',
      'price',
      'finance news'
    ],
    childDirected: false,
    nonPersonalizedAds: true,
  );
  // ignore: unused_field
  BannerAd _bannerAd;
  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: 'ca-app-pub-9000154121468885/3888822435',
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event => $event");
      },
    );
  }

  InterstitialAd interstitialAd;
  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: "ca-app-pub-9000154121468885/8763650251",
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print('InterstitialAd event $event');
      },
    );
  }

  void loadInterstitialAd() {
    interstitialAd = createInterstitialAd()
      ..load()
      ..show();
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-9000154121468885~7244024653');
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      showEnglishVersion = sp.getBool('showEnglishVersion') ?? false;
      setState(() {});
    });
    Timer(Duration(seconds: 5), () => loadInterstitialAd());
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
    interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kalimati Price Today"),
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(0, 54, 140, 1),
        actions: <Widget>[
          IconButton(
              icon: new Icon(
                Icons.help,
                color: Colors.white,
              ),
              onPressed: () => showBottomSheetModal()),
          IconButton(
              icon: new Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () => showBottomSheetModalForSetting())
        ],
      ),
      body: ContainedTabBarView(
        tabs: [
          !showEnglishVersion
              ? Text('दैनिक थोक मूल्य', style: TextStyle(color: Colors.black))
              : Text('Daily Wholesale Price',
                  style: TextStyle(color: Colors.black))
        ],
        tabBarProperties: TabBarProperties(
          indicatorColor: Color.fromRGBO(0, 54, 140, 1),
          background: Container(color: Colors.grey.shade200),
          labelStyle: TextStyle(
            fontSize: 18,
          ),
        ),
        views: [!showEnglishVersion ? NepaliVegPrice() : EnglishWebViewNew()],
        onChange: (index) => print(index),
      ),
    );
  }

  showBottomSheetModal() {
    showRoundedModalBottomSheet(
      context: context,
      radius: 20.0, // This is the default
      color: Colors.white, // Also default
      dismissOnTap: false,
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

  showBottomSheetModalForSetting() {
    showRoundedModalBottomSheet(
      context: context,
      radius: 10.0, // This is the default
      color: Colors.white, // Also default
      builder: (context) => Container(
          child: Container(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Text('Settings',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  )),
              SizedBox(
                height: 10.0,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CheckboxListTile(
                    title: Text("Show English Version"),
                    value: showEnglishVersion,
                    onChanged: (newValue) {
                      SharedPreferences.getInstance()
                          .then((SharedPreferences sp) {
                        setState(() {
                          showEnglishVersion = newValue;
                        });
                        sp.setBool('showEnglishVersion', newValue);
                        Navigator.pop(context);
                        Timer(Duration(seconds: 5), () => loadInterstitialAd());
                      });
                    },
                  ),
                  ListTile(
                    onTap: () {
                      try {
                        launch("market://details?id=" + appPackageName);
                      } on PlatformException catch (e) {
                        print(e);
                        launch(
                            "https://play.google.com/store/apps/details?id=" +
                                appPackageName);
                      } finally {
                        launch(
                            "https://play.google.com/store/apps/details?id=" +
                                appPackageName);
                      }
                    },
                    title: Text(
                      "Rate the APP",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
