import 'dart:io' show Platform;

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:khind/screens/ewarranty.dart';
import 'package:khind/screens/mall.dart';
import 'package:khind/screens/mypurchases.dart';
import 'package:khind/screens/news.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/screens/service_tracker.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final List<Widget> _tabs = [
    const News(),
    const MyPurchases(),
    const Mall(),
    const ServiceTracker(),
    const Ewarranty(),
  ];
  final autoSizeGroup = AutoSizeGroup();
  int page = 0;
  int tabIdx = 0;
  double size = 20.0;
  late AnimationController _animationController;
  late Animation<double> animation;
  late CurvedAnimation curve;
  List icons = [
    {'icon': CupertinoIcons.list_bullet, 'label': 'News'},
    {'icon': CupertinoIcons.purchased, 'label': 'My Purchases'},
    // {'icon': CupertinoIcons.home, 'label': 'Mall'},
    {'icon': CupertinoIcons.time, 'label': 'Service Tracker'},
    {'icon': CupertinoIcons.map, 'label': 'E-Warranty'},
  ];

  @override
  void initState() {
    super.initState();
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
  }

  _renderBottomNav() {
    return AnimatedBottomNavigationBar.builder(
      itemCount: icons.length,
      tabBuilder: (int index, bool isActive) {
        final color = isActive ? AppColors.secondary : AppColors.tertiery;
        return Container(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icons[index]['icon'] as IconData,
              size: 12,
              color: color,
            ),
            const SizedBox(height: 4),
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
          tabIdx = index;
          page = newPage;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(children: _tabs, index: page),
      floatingActionButton: ScaleTransition(
        scale: animation,
        child: FloatingActionButton(
          // clipBehavior: Clip.hardEdge,
          elevation: 8,
          backgroundColor: AppColors.secondary,
          child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(5),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(height: 5),
                Image(image: AssetImage('assets/images/logo_sm.png')),
                SizedBox(height: 2),
                Text("Mall", style: TextStyle(fontSize: 8))
              ])),
          onPressed: () {
            setState(() {
              // tabIdx = 5;
              page = 2;
            });
            _animationController.reset();
            _animationController.forward();
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _renderBottomNav(),
    );
  }
}
