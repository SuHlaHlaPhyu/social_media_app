import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/network/social_data_agent.dart';

const newsFeedCollection = "newsfeed";
const fileUploadRef = "uploads";

class FireStoreDatabaseDataAgentImpl extends SocialDataAgent {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  var firebaseStorage = FirebaseStorage.instance;
  @override
  Future<void> addNewPost(NewsFeedVO post) {
    return fireStore
        .collection(newsFeedCollection)
        .doc(post.id.toString())
        .set(post.toJson());
  }

  @override
  Future<void> deletePost(int postId) {
    return fireStore
        .collection(newsFeedCollection)
        .doc(postId.toString())
        .delete();
  }

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    // snapshots => real time notify
    // snapshots => querySnapshot => querySnapshot.docs => List<queryDocumentSnapshot> => data() => List<Map<String,dynamic>> => NewsfeedVO.fromJSON => List<NewsfeedVO>
    return fireStore
        .collection(newsFeedCollection)
        .snapshots()
        .map((querySnapshots) {
      return querySnapshots.docs.map<NewsFeedVO>((document) {
        return NewsFeedVO.fromJson(document.data());
      }).toList();
    });
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    // get => return Future => one time emit
    return fireStore
        .collection(newsFeedCollection)
        .doc(newsFeedId.toString())
        .get()
        .asStream()
        .where((documentSnapshot) => documentSnapshot.data() != null)
        .map((documentSnapshot) {
      return NewsFeedVO.fromJson(
          Map<String, dynamic>.from(documentSnapshot.data()!));
    });
  }

  @override
  Future<String> uploadFileToFirebase(File image) {
    return FirebaseStorage.instance
        .ref(fileUploadRef)
        .child("${DateTime.now().millisecondsSinceEpoch}")
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
  }
}
