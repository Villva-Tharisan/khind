import 'package:flutter/material.dart';

class News extends StatelessWidget {
  const News({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 15,
        ),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {
            return NewsCard();
          },
          // padding: EdgeInsets.only(bottom: 10),
        ),
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: 75,
      padding: EdgeInsets.all(5),
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
            width: width * 0.4,
            // height: MediaQuery.of(context).size.width * 0.3,
            // alignment: Alignment.topLeft,
            child: Image.network(
              'https://tworedbowls.com/wp-content/uploads/2019/08/collard-wontons-1-e1617855856563.jpg',
              height: MediaQuery.of(context).size.width * 0.2,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            width: width * 0.45,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Flexible(
                  child: Text(
                    'Floral Snow Mooncakes Recipe',
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
                  '19 Sept 2021 | Announcement',
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
