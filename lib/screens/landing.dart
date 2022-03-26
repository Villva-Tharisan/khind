import 'dart:io' show Platform;
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:khind/themes/app_colors.dart';

class Landing extends StatefulWidget {
  int? data = 0;
  Landing({this.data});

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> with SingleTickerProviderStateMixin {
  final autoSizeGroup = AutoSizeGroup();
  int page = 0;
  int tabIdx = 0;
  double size = 20.0;
  late AnimationController _animationController;
  late Animation<double> animation;
  late CurvedAnimation curve;
  List icons = [
    {'icon': 'assets/icons/mall.png', 'label': 'Mall'},
    {'icon': 'assets/icons/news.png', 'label': 'News'},
    {'icon': 'assets/icons/my_purchases.png', 'label': 'My Purchases'},
    {'icon': 'assets/icons/service_tracker.png', 'label': 'Service Tracker'}
  ];

  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
      () => _animationController.forward(),
    );

    super.initState();
  }

  _renderBottomNav() {
    return AnimatedBottomNavigationBar.builder(
      itemCount: icons.length,
      // leftCornerRadius: 32,
      // rightCornerRadius: 32,
      tabBuilder: (int index, bool isActive) {
        final color = isActive ? AppColors.secondary : AppColors.tertiery;
        return Container(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
                image: AssetImage(icons[index]['icon'] as String),
                width: 20,
                height: 20,
                color: color),
            SizedBox(height: 4),
            Container(
              // padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AutoSizeText(
                icons[index]['label'] as String,
                maxLines: 2,
                style: TextStyle(color: color, fontSize: 10),
                textAlign: TextAlign.center,
                group: autoSizeGroup,
              ),
            )
          ],
        ));
      },
      gapWidth: 50,
      backgroundColor: AppColors.primary,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.defaultEdge,
      activeIndex: tabIdx,
      onTap: (index) {
        Navigator.pushNamed(context, 'signin', arguments: index);
      },
    );
  }

  Widget _renderBody() {
    return SafeArea(
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
            )));
  }

  Future<bool> _onWillPop() async {
    setState(() {
      tabIdx = 0;
      page = 0;
    });
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // print("###PAGE: $page");
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: _renderBody(),
          floatingActionButton: ScaleTransition(
            scale: animation,
            child: FloatingActionButton(
              // clipBehavior: Clip.hardEdge,
              elevation: 8,
              backgroundColor: AppColors.primary,
              child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(2),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.add, size: 50),
                  ])),
              onPressed: () {
                // Navigator.pushNamed(context, 'EwarrantyProductManual', arguments: true);
                Navigator.pushNamed(context, 'signin', arguments: 4);
                // _animationController.reset();
                // _animationController.forward();
              },
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: _renderBottomNav(),
        ));
  }
}
