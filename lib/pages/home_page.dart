import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/blocs/news_feed_bloc.dart';
import 'package:social_media_app/resources/dimens.dart';
import 'package:social_media_app/utils/extensions.dart';
import 'package:social_media_app/viewitems/news_feed_item_view.dart';

import 'add_new_post_page.dart';
import 'login_page.dart';
import 'text_detection_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NewsFeedBloc(),
      child: Scaffold(
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TextDetectionPage(),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(
                  right: MARGIN_LARGE,
                ),
                child: const Icon(
                  Icons.face,
                  color: Colors.grey,
                  size: MARGIN_LARGE,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
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
            ),
            Consumer<NewsFeedBloc>(
              builder: (context, bloc, child) => GestureDetector(
                onTap: () {
                  bloc.onTapLogout().then(
                          (_) => navigateToScreen(context, const LoginPage()));
                },
                child: Container(
                  margin: const EdgeInsets.only(
                    right: MARGIN_LARGE,
                  ),
                  child: const Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: MARGIN_LARGE,
                  ),
                ),
              ),
            ),
            // GestureDetector(
            //   onTap: () {
            //     /// TODO : - Handle Search Here
            //   },
            //   child: Container(
            //     margin: const EdgeInsets.only(
            //       right: MARGIN_LARGE,
            //     ),
            //     child: const Icon(
            //       Icons.search,
            //       color: Colors.grey,
            //       size: MARGIN_LARGE,
            //     ),
            //   ),
            // )
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Consumer<NewsFeedBloc>(
            builder: (context, bloc, child) {
              return ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: MARGIN_LARGE,
                  horizontal: MARGIN_LARGE,
                ),
                itemBuilder: (context, index) {
                  return NewsFeedItemView(
                    newsFeed: bloc.newsFeed?[index], onTapDelete: (newsFeedId) {
                    bloc.onTapDeletePost(newsFeedId);
                  },
                    onTapEdit: (newsFeedId) {
                      Future.delayed(const Duration(milliseconds: 1000))
                          .then((value) {
                        _navigateToEditPostPage(context, newsFeedId);
                      });
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: MARGIN_XLARGE,
                  );
                },
                itemCount: bloc.newsFeed?.length ?? 0,
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            _navigateToAddNewPostPage(context);
            // FirebaseCrashlytics.instance.crash();
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _navigateToAddNewPostPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddNewPostPage(),
      ),
    );
  }
  void _navigateToEditPostPage(BuildContext context, int newsFeedId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddNewPostPage(
          newsFeedId: newsFeedId,
        ),
      ),
    );
  }
}
