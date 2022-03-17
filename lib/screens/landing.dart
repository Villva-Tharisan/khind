import 'dart:io' show Platform;
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:khind/cubit/product_group/product_group_cubit.dart';
import 'package:khind/cubit/product_model/product_model_cubit.dart';
import 'package:khind/cubit/store/store_cubit.dart';
import 'package:khind/cubit/tracker/tracker_cubit.dart';
import 'package:khind/screens/ewarranty.dart';
import 'package:khind/screens/ewarranty_product_manual.dart';
import 'package:khind/screens/mall.dart';
import 'package:khind/screens/mypurchases.dart';
import 'package:khind/screens/news_landing.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/screens/service_tracker.dart';

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
    {'icon': CupertinoIcons.shopping_cart, 'label': 'Mall'},
    {'icon': CupertinoIcons.list_bullet, 'label': 'News'},
    {'icon': CupertinoIcons.purchased, 'label': 'My Purchases'},
    {'icon': CupertinoIcons.time, 'label': 'Service Tracker'}
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
            Icon(
              icons[index]['icon'] as IconData,
              size: 20,
              color: color,
            ),
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
