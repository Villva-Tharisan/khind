import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:khind/models/new.dart';
import 'package:intl/intl.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  List<New> _news = [];
  var _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchNews();
  }

  Future<void> fetchNews() async {
    var url = Uri.parse('http://cm.khind.com.my/api/posts');
    Map<String, String> authHeader = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic a2hpbmRhcGk6S2hpbmQxcWF6MndzeDNlZGM=',
    };
    final response = await http.post(
      url,
      headers: authHeader,
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      var news = jsonResponse.map((data) => new New.fromJson(data)).toList();
      setState(() {
        _news = news;
      });
      // var x = parsed.map<New>((json) => New.fromJson(json)).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 15,
        ),
        // height: double.infinity,
        child: _news.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text("No more data to show, tap to refresh",
                      style: TextStyle(color: Colors.black)),
                ),
              )
            : RefreshIndicator(
                key: _refreshKey,
                onRefresh: fetchNews,
                child: ListView.builder(
                  itemCount: _news.length,
                  itemBuilder: (BuildContext context, int index) {
                    return NewsCard(
                      key: new Key('$index${_news[index].id}'),
                      news: _news[index],
                    );
                    // var category = _news[index].thumbnail == null
                    //     ? "aa"
                    //     : _news[index].thumbnail;
                    // return Text(category!);
                  },

                  // padding: EdgeInsets.only(bottom: 10),
                ),
              ),
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({
    Key? key,
    required this.news,
  }) : super(key: key);

  final New? news;

  @override
  Widget build(BuildContext context) {
    final category = news?.category?.name == null ? "" : news?.category?.name;
    final thumbnail = news?.thumbnail == null ? "" : news?.thumbnail;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: 75,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 0.5,
            color: Colors.grey,
            spreadRadius: 0.5,
            // offset:
          ),
        ],
        borderRadius: BorderRadius.circular(7.5),
      ),
      child: Row(
        children: [
          Container(
            // color: Colors.red,
            width: width * 0.3,
            height: MediaQuery.of(context).size.width * 0.3,
            // alignment: Alignment.topLeft,
            child: FittedBox(
              child: Image.network(
                'http://cm.khind.com.my/${thumbnail!}',
                // height: 75,
              ),
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            padding: EdgeInsets.all(5),
            width: width * 0.55,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Flexible(
                  child: Text(
                    news!.title!,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      // height: 2,
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(
                          DateFormat('yyyy-MM-dd hh:mm:ss')
                              .parse(news!.createdAt!.toString())) +
                      " | ${category!}",
                  style:
                      TextStyle(height: 2, fontSize: 12, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
