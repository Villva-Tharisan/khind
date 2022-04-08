import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:khind/models/news.dart';
import 'package:khind/models/Banners.dart';
import 'package:intl/intl.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';

class NewsLanding extends StatefulWidget {
  const NewsLanding({Key? key}) : super(key: key);

  @override
  _NewsLandingState createState() => _NewsLandingState();
}

class _NewsLandingState extends State<NewsLanding> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<News> _news = [];
  List<Banners> _banners = [];
  var _refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    this.fetchNews();
    this.fetchBanners();
    super.initState();
  }

  Future<void> fetchNews() async {
    var url = Uri.parse('https://cm.khind.com.my/api/posts');
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
      var news = jsonResponse.map((data) => new News.fromJson(data)).toList();
      setState(() {
        _news = news;
      });
      // var x = parsed.map<New>((json) => New.fromJson(json)).toList();
    }
  }

  fetchBanners() async {
    final response = await Api.bearerPost('api/banners', isCms: true);
    // print("##FetchBanners: $response");

    if (response['sliders'] != null) {
      setState(() {
        _banners =
            (response['sliders'] as List<dynamic>).map((json) => Banners.fromJson(json)).toList();
      });
    }
  }

  _renderNews() {
    return Container(
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
              child: LimitedBox(
                  maxHeight: MediaQuery.of(context).size.height * 0.2,
                  child: ListView.builder(
                    shrinkWrap: true,
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
                  )),
            ),
    );
  }

  _renderBanners() {
    double height = MediaQuery.of(context).size.height * 0.2;

    return Container(
        height: height,
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: _banners
                .map((elem) => InkWell(
                    onTap: () {
                      News tempNews = News.fromJson({'id': elem.postId});
                      Navigator.pushNamed(context, 'news_detail', arguments: tempNews);
                    },
                    child: Container(
                        padding: const EdgeInsets.only(left: 15),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(elem.imageUrl as String)))))
                .toList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: Helpers.customAppBar(context, _scaffoldKey, title: "News", isPrimary: true),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: SizedBox(height: 10)),
            // SliverToBoxAdapter()
            SliverToBoxAdapter(child: _renderBanners()),
            SliverFillRemaining(child: _renderNews())
          ],
        ));
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({
    Key? key,
    required this.news,
  }) : super(key: key);

  final News? news;

  @override
  Widget build(BuildContext context) {
    final category = news?.category?.name == null ? "" : news?.category?.name;
    final thumbnail = news?.thumbnail == null ? "" : news?.thumbnail;
    double width = MediaQuery.of(context).size.width;
    return InkWell(
        onTap: () =>
            Navigator.pushNamed(context, 'news_detail', arguments: news != null ? news : null),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(width: 0.1),
            color: Colors.white,
            boxShadow: [
              BoxShadow(blurRadius: 5, color: Colors.grey[200]!, offset: Offset(0, 10)),
            ],
            borderRadius: BorderRadius.circular(7.5),
          ),
          child: Row(
            children: [
              Container(
                  width: width * 0.3,
                  // padding: EdgeInsets.all(2),
                  height: MediaQuery.of(context).size.width * 0.25,
                  // alignment: Alignment.topLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(7.5),
                      topLeft: Radius.circular(7.5),
                    ),
                    child: Image.network(
                      'https://cm.khind.com.my/${thumbnail!}',
                      // height: 75,
                      fit: BoxFit.fill,
                    ),
                  )),
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
                    Text(
                      news!.title!,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(DateFormat('yyyy-MM-dd hh:mm:ss')
                              .parse(news!.createdAt!.toString())) +
                          " | ${category!}",
                      style: TextStyle(height: 2, fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
