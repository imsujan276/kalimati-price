import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:flutter_native_admob/flutter_native_admob.dart';

class EnglishWebViewNew extends StatefulWidget {
  @override
  _EnglishWebViewNewState createState() => _EnglishWebViewNewState();
}

class _EnglishWebViewNewState extends State<EnglishWebViewNew> {
  static const bannerAdID = "ca-app-pub-9000154121468885/3888822435";

  bool isLoading = true;
  bool hasError = false;
  var url = "https://nepalicalendar.rat32.com/vegetable/embed.php";

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final _nativeAdController = NativeAdmobController();
  double _admobHeight = 0;

  StreamSubscription _subscription;

  @override
  void initState() {
    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (BuildContext context) {
        return Column(
          children: [
            Expanded(
              child: Stack(
                children: <Widget>[
                  Container(
                    child: WebView(
                      initialUrl: url,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (WebViewController webViewController) {
                        _controller.complete(webViewController);
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
              ),
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
