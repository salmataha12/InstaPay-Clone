import 'package:flutter/material.dart';

class CollectViewModel {
  int selectedTab = 0;

  void selectTab(int index) {
    selectedTab = index;
  }
}
