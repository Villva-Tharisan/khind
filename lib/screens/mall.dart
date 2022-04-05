import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:khind/util/helpers.dart';

class Mall extends StatefulWidget {
  const Mall({Key? key}) : super(key: key);

  @override
  _MallState createState() => _MallState();
}

class _MallState extends State<Mall> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Helpers.customAppBar(context, _scaffoldKey, title: "Mall", isPrimary: true),
      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
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
