import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class FirebaseRemoteConfig {
  static final FirebaseRemoteConfig _singleton =
  FirebaseRemoteConfig._internal();

  factory FirebaseRemoteConfig() {
    return _singleton;
  }

  FirebaseRemoteConfig._internal() {
    initializeRemoteConfig();
    _remoteConfig.fetchAndActivate();
  }

  final RemoteConfig _remoteConfig = RemoteConfig.instance;

  void initializeRemoteConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(seconds: 1),
    ));
  }

  MaterialColor getThemeColorFromRemoteConfig() {
    debugPrint(
        "Remote Config Theme Color Value ======> ${_remoteConfig.getString(remoteConfigThemeColor)}");
    return MaterialColor(
      int.parse(_remoteConfig.getString(remoteConfigThemeColor)),
      const {},
    );
  }
}

const String remoteConfigThemeColor = "theme_color";
