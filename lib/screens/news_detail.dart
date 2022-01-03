import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:khind/components/round_button.dart';
import 'package:khind/models/news.dart';
import 'package:khind/themes/app_colors.dart';
import 'package:khind/themes/text_styles.dart';
import 'package:khind/util/api.dart';
import 'package:khind/util/helpers.dart';

class NewsDetail extends StatefulWidget {
  News? data;
  NewsDetail({this.data});

  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  News? news;

  @override
  void initState() {
    super.initState();
    // print("NEWS ID: ${widget.id}");
    if (widget.data != null) {
      _fetchDetail(widget.data?.id);
    }
  }

  void _fetchDetail(id) async {
    final response = await Api.bearerPost('api/post/$id', isCms: true);

    if (response != null) {
      News tempNews = News.fromJson(response);
      setState(() {
        news = tempNews;
      });
    }
  }

  Widget _renderBody() {
    if (news?.content != null) {
      return Container(
          padding: EdgeInsets.symmetric(horizontal: 10), child: Html(data: news!.content));
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: Helpers.customAppBar(context, _scaffoldKey,
          title: news != null ? '${news?.title}' : 'News', isBack: true, hasActions: false),
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _renderBody(),
        )
      ]),
    );
  }
}
