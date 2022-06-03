import 'package:social_media_app/data/models/social_model.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/network/real_time_database_data_agent_impl.dart';
import 'package:social_media_app/network/social_data_agent.dart';

class SocialModelImpl extends SocialModel {
  static final SocialModelImpl _singleton = SocialModelImpl._internal();

  SocialModelImpl._internal();

  factory SocialModelImpl() {
    return _singleton;
  }

  SocialDataAgent dataAgent = RealTimeDatabaseDataAgentImpl();
  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    return dataAgent.getNewsFeed();
  }

  @override
  Future<void> addNewPost(String description) {
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    var newPost = NewsFeedVO(
        id: currentTime,
        description: description,
        userName: "Su Hla Hla Phyu",
        postImage: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-1.2.1&w=1080&fit=max&q=80&fm=jpg&crop=entropy&cs=tinysrgb",
        profilePicture: "https://wallpaperaccess.com/full/3256855.jpg");
    return dataAgent.addNewPost(newPost);
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
  Future<void> editPost(NewsFeedVO newsFeed) {
    return dataAgent.addNewPost(newsFeed);
  }
}
