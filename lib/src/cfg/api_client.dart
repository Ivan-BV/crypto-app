import 'dart:convert';

import 'package:cryptoapp/src/cfg/models.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static const baseUrl = "https://api.coingecko.com/api/v3/";

  Future<Coin> getCoin(String coinId, {bool localization = false}) async {
    final response = await http.get(Uri.parse(
        "$baseUrl/coins/$coinId?x_cg_demo_api_key=CG-pwmwZs2wnsKuTmftserUCWbn&localization=$localization&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=false"));
    if (response.statusCode == 200) {
      return Coin.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load coin');
    }
  }

  Future<MarketChart> getCoinMarketChartInfo(String coinId) async {
    String days = "30";
    String interval = "daily";

    final response = await http.get(Uri.parse(
        "$baseUrl/coins/$coinId/market_chart?x_cg_demo_api_key=CG-pwmwZs2wnsKuTmftserUCWbn&vs_currency=eur&days=$days&interval=$interval"));
    if (response.statusCode == 200) {
      return MarketChart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error getting chart data");
    }
  }

  Future<CoinMarketInfo> getCoinMarketInfo(String coinId) async {
    final response = await http.get(Uri.parse(
        "$baseUrl/coins/$coinId?x_cg_demo_api_key=CG-pwmwZs2wnsKuTmftserUCWbn&localization=false&tickers=false&market_data=true&community_data=true&developer_data=true&sparkline=false"));
    if (response.statusCode == 200) {
      return CoinMarketInfo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load coin');
    }
  }

  Future<List<Coin>> getCoins(List<String> coinsIds) async {
    List<Coin> coins = [];
    for (String id in coinsIds) {
      coins.add(await getCoin(id));
    }
    return coins;
  }
}
