import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app/data/vos/news_feed_vo.dart';
import 'package:social_media_app/data/vos/user_vo.dart';
import 'package:social_media_app/network/social_data_agent.dart';

const newsFeedPath = "newsfeed";
const usersPath = "users";

const fileUploadRef = "uploads";

class RealTimeDatabaseDataAgentImpl extends SocialDataAgent {
  static final RealTimeDatabaseDataAgentImpl _singleton =
      RealTimeDatabaseDataAgentImpl._internal();

  RealTimeDatabaseDataAgentImpl._internal();

  factory RealTimeDatabaseDataAgentImpl() {
    return _singleton;
  }

  /// Database ref
  var databaseRef = FirebaseDatabase.instance.reference();

  /// Storage
  var firebaseStorage = FirebaseStorage.instance;

  /// Auth
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Stream<List<NewsFeedVO>> getNewsFeed() {
    // onValue => real time notify => return Stream => every time emit
    return databaseRef.child(newsFeedPath).onValue.map((event) {
      // event.snapshot.value => List<Object> => Map<String, dynamic> => VO // with simple key eg.1,2,3,4
      //  return event.snapshot.value.map<NewsFeedVO>((element) {
      //    return NewsFeedVO.fromJson(Map<String, dynamic>.from(element));
      //  }).toList();

      // event.snapshot.value => Map<String, dynamic>
      // event.snapshot.value.values => List<Map<String, dynamic>> => NewsFeedVO.fromJson => List<NewsFeedVO> // with complex key eg.12547,12548
      return event.snapshot.value.values.map<NewsFeedVO>((element) {
        return NewsFeedVO.fromJson(Map<String, dynamic>.from(element));
      }).toList();
    });
  }

  @override
  Future<void> addNewPost(NewsFeedVO post) {
    return databaseRef
        .child(newsFeedPath)
        .child(post.id.toString())
        .set(post.toJson());
  }

  @override
  Future<void> deletePost(int postId) {
    return databaseRef.child(newsFeedPath).child(postId.toString()).remove();
  }

  @override
  Stream<NewsFeedVO> getNewsFeedById(int newsFeedId) {
    // once => return Future => one time emit
    return databaseRef
        .child(newsFeedPath)
        .child(newsFeedId.toString())
        .once()
        .asStream()
        .map((event) {
      return NewsFeedVO.fromJson(Map<String, dynamic>.from(event.value));
    });
  }

  @override
  Future<String> uploadFileToFirebase(File image) {
    print("=======> upload file to firebase");
    return firebaseStorage
        .ref(fileUploadRef)
        .child("${DateTime.now().millisecondsSinceEpoch}")
        .putFile(image)
        .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());
  }


  @override
  Future registerNewUser(UserVO newUser) {
    return auth
        .createUserWithEmailAndPassword(
        email: newUser.email ?? "", password: newUser.password ?? "")
        .then((credential) =>
    credential.user?..updateDisplayName(newUser.userName))
        .then((user) {
      newUser.id = user?.uid ?? "";
      _addNewUser(newUser);
    });
  }

  Future<void> _addNewUser(UserVO newUser) {
    return databaseRef
        .child(usersPath)
        .child(newUser.id.toString())
        .set(newUser.toJson());
  }

  @override
  Future login(String email, String password) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  @override
  UserVO getLoggedInUser() {
    return UserVO(
      id: auth.currentUser?.uid,
      email: auth.currentUser?.email,
      userName: auth.currentUser?.displayName,
    );
  }

  @override
  Future logOut() {
    return auth.signOut();
  }
}
