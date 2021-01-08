import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:kalimati_price/pages/english_web_view.dart';
// import 'package:kalimati_price/pages/nepali_page.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final controller = PageController();
  bool showEnglishVersion = false;

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
        ],
      ),
      body: EnglishWebViewNew(),
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
}
