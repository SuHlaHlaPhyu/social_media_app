import 'package:flutter/cupertino.dart';
import 'package:social_media_app/data/models/social_model.dart';
import 'package:social_media_app/data/models/social_model_impl.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';

class NewsFeedBloc extends ChangeNotifier {
  List<NewsFeedVO>? newsFeed;

  final SocialModel model = SocialModelImpl();

  bool isDisposed = false;

  NewsFeedBloc(){
    model.getNewsFeed().listen((list) {
      newsFeed = list;
      if(!isDisposed){
        notifyListeners();
      }
    });
  }
  void onTapDeletePost(int postId) async {
    await model.deletePost(postId);
  }
  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}