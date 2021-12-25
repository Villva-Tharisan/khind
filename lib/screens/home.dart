import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:khind/screens/ewarranty.dart';
import 'package:khind/screens/mall.dart';
import 'package:khind/screens/mypurchases.dart';
import 'package:khind/screens/news.dart';
import 'package:khind/screens/servicelocator.dart';
import 'package:khind/screens/servicetracker.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> _tabs = [
    const News(),
    // const ServiceLocator(),
    const MyPurchases(),
    const Mall(),
    const ServiceTracker(),
    const Ewarranty(),
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Khind'),
      ),
      child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.list_bullet), label: 'News'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.purchased), label: 'My Purchases'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home), label: 'Mall'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.time), label: 'Service Tracker'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.map), label: 'eWaranty'),
            ],
          ),
          tabBuilder: (BuildContext context, index) {
            return _tabs[index];
          }),
    );
  }
}
