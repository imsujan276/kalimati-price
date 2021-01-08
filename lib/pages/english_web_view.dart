import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EnglishWebViewNew extends StatefulWidget {
  @override
  _EnglishWebViewNewState createState() => _EnglishWebViewNewState();
}

class _EnglishWebViewNewState extends State<EnglishWebViewNew> {
  bool isLoading = true;
  bool hasError = false;
  var url = "https://nepalicalendar.rat32.com/vegetable/embed.php";

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                    color: Colors.green[100],
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
                                    'Error getting data',
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
              height: 50.0,
            ),
          ],
        );
      }),
    );
  }
}
