import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:rounded_modal/rounded_modal.dart';

class HomePageNew extends StatefulWidget {
  @override
  _HomePageNewState createState() => _HomePageNewState();
}

class _HomePageNewState extends State<HomePageNew> {
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
              onPressed: () => {showBottomSheetModal()})
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: 'https://nepalicalendar.rat32.com/vegetable/embed.php',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
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
