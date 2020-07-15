import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:rounded_modal/rounded_modal.dart';

import 'package:flutter_native_admob/flutter_native_admob.dart';

class HomePageNew extends StatefulWidget {
  @override
  _HomePageNewState createState() => _HomePageNewState();
}

class _HomePageNewState extends State<HomePageNew> {
  static const bannerAdID = "ca-app-pub-9000154121468885/3888822435";
  final nativeAdMob = NativeAdmob();

  bool isLoading = true;
  bool hasError = false;
  var url = "https://nepalicalendar.rat32.com/vegetable/embed.php";

  @override
  void initState() {
    super.initState();
    nativeAdMob.initialize(appID: "ca-app-pub-9000154121468885~7244024653");
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kalimati Price Today"),
        elevation: 0.0,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(
                Icons.help,
                color: Colors.white,
              ),
              onPressed: () => showBottomSheetModal())
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            NativeAdmobBannerView(
              adUnitID: bannerAdID,
              style: BannerStyle.light, // enum dark or light
              showMedia: true, // whether to show media view or not
            ),
            WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onPageStarted: (String url) {
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                if (!hasError) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              onWebResourceError: (WebResourceError error) {
                print(error);
                setState(() {
                  isLoading = false;
                  hasError = true;
                });
              },
              gestureNavigationEnabled: true,
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : hasError
                    ? Container(
                        color: Colors.grey,
                        child: Center(
                          child: RaisedButton(
                            onPressed: () => SystemNavigator.pop(),
                            child: Text(
                              'No Internet Connection',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.redAccent,
                          ),
                        ))
                    : Container(),
          ],
        );
      }),
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
