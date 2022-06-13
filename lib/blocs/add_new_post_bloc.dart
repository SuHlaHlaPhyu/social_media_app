import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_media_app/data/models/social_model_impl.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/analytics/firebase_analytics_tracker.dart';
import 'package:social_media_app/remote_config/firebase_remote_config.dart';

import '../data/models/authentication_model.dart';
import '../data/models/authentication_model_impl.dart';
import '../data/models/social_model.dart';
import '../data/vos/user_vo.dart';

class AddNewPostBloc extends ChangeNotifier {
  String newPostDescription = "";
  bool isAddNewPostError = false;
  bool isDisposed = false;
  bool isLoading = false;
  bool isRemove = false;
  UserVO? _loggedInUser;

  /// Edit post
  bool isEditMode = false;
  String userName = "";
  String profilePicture = "";
  String postedImage = "";
  NewsFeedVO? newsFeed;

  File? chosenImageFile;

  Color themeColor = Colors.black;

  final SocialModel _model = SocialModelImpl();

  final AuthenticationModel authModel = AuthenticationModelImpl();
  /// Remote Configs
  final FirebaseRemoteConfig _firebaseRemoteConfig = FirebaseRemoteConfig();

  AddNewPostBloc({int? newsFeedId}) {
    _loggedInUser = authModel.getLoggedInUser();
    if (newsFeedId != null) {
      isEditMode = true;
      isRemove = true;
      prepareDataForEditMode(newsFeedId);
    } else {
      prepareDataForNewPostMode();
    }

    /// Firebase
    _sendAnalyticsData(addNewPostScreenReached, null);
    _getRemoteConfigAndChangeTheme();
  }
  void _getRemoteConfigAndChangeTheme() {
    themeColor = _firebaseRemoteConfig.getThemeColorFromRemoteConfig();
    _notifySafely();
  }

  void prepareDataForNewPostMode() {
    userName = _loggedInUser?.userName ?? "";
    profilePicture =
        "https://bestprofilepictures.com/wp-content/uploads/2021/08/Anime-Girl-Profile-Picture.jpg";
    _notifySafely();
  }

  void prepareDataForEditMode(int newsFeedId) {
    _model.getNewsFeedById(newsFeedId).listen((newsFeedItem) {
      userName = newsFeedItem.userName ?? "";
      profilePicture = newsFeedItem.profilePicture ?? "";
      newPostDescription = newsFeedItem.description ?? "";
      postedImage = newsFeedItem.postImage ?? "";
      newsFeed = newsFeedItem;
      _notifySafely();
    });
  }

  void onImageChosen(File imageFile) {
    chosenImageFile = imageFile;
    _notifySafely();
  }

  void onTapDeleteImage() {
    chosenImageFile = null;
    isRemove = false;
    _notifySafely();
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
      isLoading = true;
      _notifySafely();
      isAddNewPostError = false;
      if (isEditMode) {
        return editNewsFeedPost().then((value) {
          isLoading = false;
          _notifySafely();
          _sendAnalyticsData(
              editPostAction, {postId: newsFeed?.id.toString() ?? ""});
        });
      } else {
        return createNewNewsFeedPost().then((value) {
          print("=====> post");
          isLoading = false;
          _notifySafely();
          _sendAnalyticsData(addNewPostAction, null);
        });
      }
    }
  }

  Future<dynamic> editNewsFeedPost() {
    newsFeed?.description = newPostDescription;
    if (newsFeed != null) {
      return _model.editPost(newsFeed!, chosenImageFile);
    } else {
      return Future.error("Error");
    }
  }

  Future<void> createNewNewsFeedPost() {
    return _model.addNewPost(newPostDescription, chosenImageFile);
  }

  /// Analytics
  void _sendAnalyticsData(String name, Map<String, String>? parameters) async {
    await FirebaseAnalyticsTracker().logEvent(name, parameters);
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }
}
