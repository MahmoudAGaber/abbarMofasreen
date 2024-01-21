import 'package:dream2/models/dream.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  int indexScreen = 0;
  List<Dream> userDreams = <Dream>[];
  String? currentAudioIdId;

  setIndexScreen(int value) {
    this.indexScreen = value;
    notifyListeners();
  }

  updateDreams(List<Dream> dreams, int start) {
    if (start == 0) userDreams.clear();
    userDreams.addAll(dreams);
    notifyListeners();
  }

  int indexDescribe = -1;

  setIndexDescribe(int value) {
    this.indexDescribe = value;
    notifyListeners();
  }

  setCurrentAudio(String value) {
    this.currentAudioIdId = value;
    notifyListeners();
  }
}
