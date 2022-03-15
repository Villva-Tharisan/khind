import 'dart:io' show Platform;
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class Home extends StatefulWidget {
  int? data = 0;
  Home({this.data});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final List<Widget> _tabs = [
    const Mall(),
    const NewsLanding(),
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductGroupCubit(),
        ),
        BlocProvider(
          create: (context) => ProductModelCubit(),
        ),
        BlocProvider(
          create: (context) => StoreCubit(),
        ),
      ],
      child: EwarrantyProductManual(isFromWarranty: false),
    ),
    const MyPurchases(),
    BlocProvider(
      create: (context) => TrackerCubit(),
      child: ServiceTracker(),
    )
  ];
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
    {'icon': CupertinoIcons.time, 'label': 'Service Tracker'},
  ];
  bool isTabPress = false;

  @override
  void initState() {
    // print("##WIDGET DATA: ${widget.data}");
    if (widget.data != null) {
      bool triggerTabPress = false;
      if (widget.data == 0) {
        triggerTabPress = true;
        page = 0;
        tabIdx = 0;
      } else if (widget.data == 1) {
        triggerTabPress = true;
        page = 1;
        tabIdx = 1;
      } else if (widget.data == 2) {
        triggerTabPress = true;
        page = 3;
        tabIdx = 2;
      } else if (widget.data == 3) {
        triggerTabPress = true;
        page = 4;
        tabIdx = 3;
      } else if (widget.data == 4) {
        page = 2;
        tabIdx = 0;
      }
      setState(() {
        isTabPress = triggerTabPress;
      });
    }

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
        // print("IDX: $index |${widget.data}");
        final color = isActive && isTabPress ? AppColors.secondary : AppColors.tertiery;
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
      gapWidth: 60,
      backgroundColor: AppColors.primary,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.defaultEdge,
      activeIndex: tabIdx,
      onTap: (index) {
        int newPage = index;

        if (index == 2) {
          newPage = 3;
        } else if (index == 3) {
          newPage = 4;
        }
        setState(() {
          isTabPress = true;
          tabIdx = index;
          page = newPage;
        });
      },
    );
  }

  Future<bool> _onWillPop() async {
    setState(() {
      isTabPress = true;
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
          body: IndexedStack(children: _tabs, index: page),
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
                    // SizedBox(height: 5),
                    // Image(image: AssetImage('assets/images/logo_sm.png')),
                    Icon(Icons.add, size: 50),
                    // SizedBox(height: 2),
                    // Text("E-Warranty", style: TextStyle(fontSize: 6))
                  ])),
              onPressed: () {
                setState(() {
                  isTabPress = true;
                  page = 2;
                });
                _animationController.reset();
                _animationController.forward();
              },
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: _renderBottomNav(),
        ));
  }
}
