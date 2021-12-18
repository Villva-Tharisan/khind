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
            return Card();
          },
          // padding: EdgeInsets.only(bottom: 10),
        ),
      ),
    );
  }
}

class Card extends StatelessWidget {
  const Card({
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
            height: MediaQuery.of(context).size.width * 0.3,
            // alignment: Alignment.topLeft,
            child: Image.network(
              'https://www.kitchen-arena.com.my/media/catalog/product/cache/926507dc7f93631a094422215b778fe0/o/t/ot50.png',
              height: MediaQuery.of(context).size.width * 0.2,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Khind Freezer Series',
                  style: TextStyle(
                    height: 2,
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
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
