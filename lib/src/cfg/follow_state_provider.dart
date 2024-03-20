import 'package:cryptoapp/src/cfg/follow_preferences.dart';
import 'package:flutter/material.dart';

class FollowState extends ChangeNotifier {
  List<String> _followedCoinsIds = [];

  List<String> get followedCoinsIds => _followedCoinsIds;

  set followedCoinsIds(List<String> coinsIds) {
    _followedCoinsIds = coinsIds;
    notifyListeners();
  }

  void add(String coinId) {
    _followedCoinsIds.add(coinId);
    notifyListeners();
    FollowPreferences().saveFollowedCoin(coinId);
  }

  void remove(String coinId) {
    _followedCoinsIds.remove(coinId);
    notifyListeners();
    FollowPreferences().deleteFollowedCoin(coinId);
  }
}
