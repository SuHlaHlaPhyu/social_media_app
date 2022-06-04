import 'dart:io';

import 'package:social_media_app/data/vos/news_feed_vo.dart';

abstract class SocialModel {
  Stream<List<NewsFeedVO>> getNewsFeed();
  Future<void> addNewPost(String description, File? image);
  Future<void> deletePost(int postId);
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId);
  Future<void> editPost(NewsFeedVO newsFeed, File? image);
}