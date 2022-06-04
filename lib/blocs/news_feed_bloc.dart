import 'package:flutter/cupertino.dart';
import 'package:social_media_app/data/models/authentication_model.dart';
import 'package:social_media_app/data/models/authentication_model_impl.dart';
import 'package:social_media_app/data/models/social_model.dart';
import 'package:social_media_app/data/models/social_model_impl.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';

class NewsFeedBloc extends ChangeNotifier {
  List<NewsFeedVO>? newsFeed;

  final SocialModel model = SocialModelImpl();

  final AuthenticationModel authModel = AuthenticationModelImpl();

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

  Future onTapLogout() {
    return authModel.logOut();
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}