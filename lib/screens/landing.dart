import 'dart:io' show Platform;
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/themes/text_styles.dart';

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
        final color = isActive ? AppColors.tertiery : AppColors.tertiery;
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
      elevation: 0,
      backgroundColor: Colors.transparent,
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
            child: Container(
              height: 70.0,
              width: 70.0,
              child: FittedBox(
                  alignment: Alignment.center,
                  child: FloatingActionButton(
                      backgroundColor: AppColors.primary,
                      onPressed: () {
                        Navigator.pushNamed(context, 'signin', arguments: 4);
                      },
                      child: Container(
                        child: Text("Register Product",
                            textAlign: TextAlign.center,
                            style: TextStyles.textDefaultBold
                                .copyWith(fontSize: 8, fontWeight: FontWeight.w700)),
                      ))),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: _renderBottomNav(),
        ));
  }
}
