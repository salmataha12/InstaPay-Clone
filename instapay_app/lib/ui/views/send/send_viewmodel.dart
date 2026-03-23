import 'package:flutter/material.dart';

class SendViewModel {
  int selectedTab = 0;

  void selectTab(int index) {
    selectedTab = index;
  }
}