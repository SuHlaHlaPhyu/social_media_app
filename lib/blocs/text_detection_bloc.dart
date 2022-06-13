import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:social_media_app/ml_kit/ml_kit_text_recognition.dart';

class TextDetectionBloc extends ChangeNotifier {
  File? chosenImageFile;

  final MLKitTextRecognition _kitTextRecognition = MLKitTextRecognition();

  onImageChosen(File imageFile, Uint8List bytes){
    chosenImageFile = imageFile;
    _kitTextRecognition.detectTexts(imageFile);
    notifyListeners();
  }
}