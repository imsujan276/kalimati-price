import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class NepaliVegPrice extends StatefulWidget {
  @override
  _NepaliVegPriceState createState() => _NepaliVegPriceState();
}

class _NepaliVegPriceState extends State<NepaliVegPrice> {
  static const bannerAdID = "ca-app-pub-9000154121468885/3888822435";
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  bool isLoading = true;
  bool hasError = false;
  var url = 'https://kalimatimarket.gov.np/priceinfo/dlypricebulletin';

  final _nativeAdController = NativeAdmobController();
  double _admobHeight = 0;

  StreamSubscription _subscription;

  Future<dynamic> nepaliData;

  @override
  void initState() {
    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    nepaliData = fetchData();
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _nativeAdController.dispose();
    super.dispose();
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          _admobHeight = 0;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          _admobHeight = 75;
        });
        break;
      default:
        break;
    }
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
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return CircularProgressIndicator();
                },
              )),
            ),
            SizedBox(
                height: _admobHeight,
                child: NativeAdmob(
                  adUnitID: bannerAdID,
                  loading: Container(),
                  controller: _nativeAdController,
                  type: NativeAdmobType.full,
                  // error: Text("Failed to load the ad"),
                )),
          ],
        );
      }),
    );
  }
}
