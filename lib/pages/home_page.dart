import 'package:flutter/material.dart';
import 'package:social_media_app/resources/dimens.dart';
import 'package:social_media_app/viewitems/news_feed_item_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Container(
          margin: const EdgeInsets.only(
            left: MARGIN_MEDIUM,
          ),
          child: const Text(
            "Social",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: TEXT_HEADING_1X,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              /// TODO : - Handle Search Here
            },
            child: Container(
              margin: const EdgeInsets.only(
                right: MARGIN_LARGE,
              ),
              child: const Icon(
                Icons.search,
                color: Colors.grey,
                size: MARGIN_LARGE,
              ),
            ),
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(
            vertical: MARGIN_LARGE,
            horizontal: MARGIN_LARGE,
          ),
          itemBuilder: (context, index) {
            return const NewsFeedItemView();
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: MARGIN_XLARGE,
            );
          },
          itemCount: 10,
        ),
      ),
    );
  }
}