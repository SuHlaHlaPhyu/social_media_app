import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:social_media_app/data/models/social_model.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/network/firestore_database_data_agent_impl.dart';
import 'package:social_media_app/network/real_time_database_data_agent_impl.dart';
import 'package:social_media_app/network/social_data_agent.dart';

import 'authentication_model.dart';
import 'authentication_model_impl.dart';

class SocialModelImpl extends SocialModel {
  static final SocialModelImpl _singleton = SocialModelImpl._internal();

  SocialModelImpl._internal();

  factory SocialModelImpl() {
    return _singleton;
  }

  /// real time database
  //SocialDataAgent dataAgent = RealTimeDatabaseDataAgentImpl();

  /// fire store database
  SocialDataAgent dataAgent = FireStoreDatabaseDataAgentImpl();

  final AuthenticationModel _authenticationModel = AuthenticationModelImpl();

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return dataAgent.getNewsFeed();
  }

  @override
  Future<void> addNewPost(String description, File? imageFile) {
    if (imageFile != null) {
      print("======> with image");
      return dataAgent
          .uploadFileToFirebase(imageFile)
          .then((downloadUrl) => craftNewsFeedVO(description, downloadUrl))
          .then((newPost) => dataAgent.addNewPost(newPost),);
    } else {
      return craftNewsFeedVO(description, "")
          .then((newPost) => dataAgent.addNewPost(newPost),);
    }
  }

  Future<NewsFeedVO> craftNewsFeedVO(String description, String imageUrl) {
    var currentMilliseconds = DateTime.now().millisecondsSinceEpoch;
    var newPost = NewsFeedVO(
      id: currentMilliseconds,
      userName: _authenticationModel.getLoggedInUser().userName,
      postImage: imageUrl,
      description: description,
      profilePicture:
          "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    );
    print("=======> prepare craft newsfeed");
    return Future.value(newPost);
  }

  Future<NewsFeedVO> craftNewsFeedVOForEdit (NewsFeedVO newsFeed, String imageUrl){
    newsFeed.postImage = imageUrl;
    return Future.value(newsFeed);
  }

  @override
  Future<void> deletePost(int postId) {
    return dataAgent.deletePost(postId);
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    return dataAgent.getNewsFeedById(newsFeedId);
  }

  @override
  Future<void> editPost(NewsFeedVO newsFeed,File? image) {
    if(image != null){
      return dataAgent.uploadFileToFirebase(image).then((downloadUrl) => craftNewsFeedVOForEdit(newsFeed, downloadUrl)).then((value) => dataAgent.addNewPost(value));
    } else {
      return dataAgent.addNewPost(newsFeed);
    }
  }
}
