import 'package:shared_preferences/shared_preferences.dart';

class FollowPreferences {
  final String _keyName = "followed_coins";

  void saveFollowedCoin(String coinId) {
    SharedPreferences.getInstance().then((prefs) {
      var coins = prefs.getStringList(_keyName) ?? [];
      coins.add(coinId);
      prefs.setStringList(_keyName, coins);
    });
  }

  void deleteFollowedCoin(String coinId) {
    SharedPreferences.getInstance().then((prefs) {
      var coins = prefs.getStringList(_keyName) ?? [];
      coins.remove(coinId);
      prefs.setStringList(_keyName, coins);
    });
  }

  Future<List<String>> getFollowedCoins() async {
    List<String> coins = [];
    await SharedPreferences.getInstance().then((prefs) {
      coins = prefs.getStringList(_keyName) ?? [];
    });
    return coins;
  }

  Future<List<String>> retrieveAllCoins() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyName) ?? [];
  }
}
