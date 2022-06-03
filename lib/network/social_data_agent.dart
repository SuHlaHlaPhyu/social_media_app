import 'package:social_media_app/data/vos/news_feed_vo.dart';

abstract class SocialDataAgent {
  Stream<List<NewsFeedVO>> getNewsFeed();
  Future<void> addNewPost(NewsFeedVO post);
  Future<void> deletePost(int postId);
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId);
}