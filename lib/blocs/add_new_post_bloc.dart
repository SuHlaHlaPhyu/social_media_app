import 'package:flutter/material.dart';
import 'package:social_media_app/data/models/social_model_impl.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';

import '../data/models/social_model.dart';

class AddNewPostBloc extends ChangeNotifier {
  String newPostDescription = "";
  bool isAddNewPostError = false;
  bool isDisposed = false;

  /// Edit post
  bool isEditMode = false;
  String userName = "";
  String profilePicture = "";
  NewsFeedVO? newsFeed;

  final SocialModel _model = SocialModelImpl();

  AddNewPostBloc({int? newsFeedId}){
    if(newsFeedId != null){
      isEditMode = true;
      prepareDataForEditMode(newsFeedId);
    } else {
      prepareDataForNewPostMode();
    }
  }

  void prepareDataForNewPostMode(){
    userName = "Su Hla Hla Phyu";
    profilePicture = "https://bestprofilepictures.com/wp-content/uploads/2021/08/Anime-Girl-Profile-Picture.jpg";
    _notifySafely();
  }

  void prepareDataForEditMode(int newsFeedId){
    _model.getNewsFeedById(newsFeedId).listen((newsFeedItem) {
      userName = newsFeedItem.userName ?? "";
      profilePicture = newsFeedItem.profilePicture ?? "";
      newPostDescription = newsFeedItem.description ?? "";
      newsFeed = newsFeedItem;
      _notifySafely();
    });
  }

  void onNewPostTextChanged(String newPostDescription) {
    this.newPostDescription = newPostDescription;
  }

  Future onTapAddNewPost() {
    if (newPostDescription.isEmpty) {
      isAddNewPostError = true;
      _notifySafely();
      return Future.error("Error");
    } else {
      isAddNewPostError = false;
      if(isEditMode){
         return editNewsFeedPost();
      } else {
       return createNewNewsFeedPost();
      }

    }
  }

  Future<dynamic> editNewsFeedPost(){
    newsFeed?.description = newPostDescription;
    if(newsFeed != null){
      return _model.editPost(newsFeed!);
    } else {
      return Future.error("Error");
    }
  }
  Future<void> createNewNewsFeedPost(){
    return _model.addNewPost(newPostDescription);
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }
}
