import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class NepaliVegPrice extends StatefulWidget {
  @override
  _NepaliVegPriceState createState() => _NepaliVegPriceState();
}

class _NepaliVegPriceState extends State<NepaliVegPrice> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  bool isLoading = true;
  bool hasError = false;
  var url = 'https://kalimatimarket.gov.np/priceinfo/dlypricebulletin';

  Future<dynamic> nepaliData;

  @override
  void initState() {
    nepaliData = fetchData();
    super.initState();
  }

  Future<dynamic> fetchData() async {
    final response =
        await http.post(url, body: {'cdate': '', 'pricetype': 'W'});
    if (response.statusCode == 200) {
      return "data:text/html;charset=utf-8," +
          Uri.encodeComponent(response.body);
    } else {
      throw Exception('Unable to fetch nepali price');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Column(
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
                            },
                          )),
                    );
                  } else if (snapshot.hasError) {
                    return Container(
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
                        ));
                  }

                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              )),
            ),
            SizedBox(
              height: 75.0,
            ),
          ],
        );
      }),
    );
  }
}
