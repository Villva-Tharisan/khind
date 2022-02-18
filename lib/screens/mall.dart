import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Mall extends StatefulWidget {
  const Mall({Key? key}) : super(key: key);

  @override
  _MallState createState() => _MallState();
}

class _MallState extends State<Mall> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    // height: MediaQuery.of(context).size.height * 0.6,
                    child: InAppWebView(
                      androidOnPermissionRequest: (controller, origin, resources) async {
                        return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT,
                        );
                      },
                      initialUrlRequest: URLRequest(
                        url: Uri.parse('https://www.khind.com.my/'),
                      ),
                      initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          useShouldOverrideUrlLoading: false,
                          mediaPlaybackRequiresUserGesture: false,
                          useOnDownloadStart: true,
                        ),
                        android: AndroidInAppWebViewOptions(
                          hardwareAcceleration: true,
                        ),
                        ios: IOSInAppWebViewOptions(
                          allowsInlineMediaPlayback: true,
                        ),
                      ),
                      onConsoleMessage: (controller, consoleMessage) {
                        // print(consoleMessage);
                      },
                      onLoadStop: (controller, url) async {
                        print('current url is $url');
                      },
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
