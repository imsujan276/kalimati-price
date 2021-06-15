import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:html/parser.dart' show parse;

class NepaliVegPrice extends StatefulWidget {
  @override
  _NepaliVegPriceState createState() => _NepaliVegPriceState();
}

class _NepaliVegPriceState extends State<NepaliVegPrice> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController _myController;

  bool isLoading = true;
  bool hasError = false;

  Future<dynamic> nepaliData;
  final webScraper = WebScraper('https://kalimatimarket.gov.np');

  @override
  void initState() {
    nepaliData = fetchData();
    super.initState();
  }

  Future<dynamic> fetchData() async {
    if (await webScraper.loadWebPage('')) {
      String pageContent = webScraper.getPageContent();
      var document = parse(pageContent);
      var table =
          document.querySelector("div > #commodityPricesDailyTable").outerHtml;
      return "data:text/html;charset=utf-8," + Uri.encodeComponent(table);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Container(
          child: Column(
            children: [
              Expanded(
                child: Center(
                    child: FutureBuilder<dynamic>(
                  future: nepaliData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: WebView(
                            initialUrl: snapshot.data,
                            javascriptMode: JavascriptMode.unrestricted,
                            onWebViewCreated:
                                (WebViewController webViewController) {
                              _controller.complete(webViewController);
                              _myController = webViewController;
                            },
                            onPageFinished: (String url) {
                              _myController.evaluateJavascript(
                                  "document.getElementsByClassName(\"features-inner\")[0].style.backgroundColor='#ffffff';");
                            },
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Container(
                          color: Colors.grey,
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () => SystemNavigator.pop(),
                              child: Text(
                                'Error Getting Data. Exit',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ));
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                )),
              ),
              SizedBox(
                height: 50.0,
              ),
            ],
          ),
        );
      }),
    );
  }
}
