import 'package:cryptoapp/src/cfg/follow_state_provider.dart';
import 'package:cryptoapp/src/cfg/api_client.dart';
import 'package:cryptoapp/src/pages/coin_data/coin_market_chart.dart';
import 'package:cryptoapp/src/cfg/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CoinDetails extends StatelessWidget {
  final Coin coin;

  const CoinDetails({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormatter =
        NumberFormat.simpleCurrency(name: "EUR");
    bool isUp = coin.priceChange24Percentage >= 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Padding(
            padding: const EdgeInsets.only(right: 45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  coin.imageUrl,
                  width: 32,
                ),
                const Padding(padding: EdgeInsets.only(right: 5, left: 2)),
                Text(
                  coin.name.toUpperCase(),
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            )),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  coin.symbol.toUpperCase(),
                  style: const TextStyle(fontSize: 28),
                ),
                const Padding(padding: EdgeInsets.only(bottom: 15)),
                Row(
                  children: [
                    Text(
                      "EUR${currencyFormatter.format(coin.priceVsEur)}",
                      style: const TextStyle(fontSize: 25),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: isUp ? Colors.green : Colors.red),
                      child: Row(
                        children: [
                          Icon(
                            isUp
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          Text(
                            "${NumberFormat("####.##").format(coin.priceChange24Percentage)}%",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 25)),
                CoinMarketChart(coinId: coin.id),
                const Padding(padding: EdgeInsets.only(bottom: 20)),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black87,
                  ),
                  child: DefaultTextStyle(
                      style: const TextStyle(color: Colors.white),
                      child: MarketInfoRows(coin.id, currencyFormatter)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      backgroundColor: Colors.yellow,
                    ),
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.black87,
                    ),
                    label: const Text(
                      "Follow coin",
                      style: TextStyle(color: Colors.black87),
                    ),
                    onPressed: () {
                      onFollowingCoin(context, coin.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Following ${coin.name}"),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void onFollowingCoin(BuildContext context, String coinId) {
  var followState = Provider.of<FollowState>(context, listen: false);
  followState.add(coinId);
}

class MarketInfoRows extends StatelessWidget {
  final String coinId;
  final NumberFormat currencyFormatter;

  const MarketInfoRows(this.coinId, this.currencyFormatter, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CoinMarketInfo>(
        future: ApiClient().getCoinMarketInfo(coinId),
        builder: (context, snapshot) {
          List<Widget> rows = [];
          if (!snapshot.hasData) {
            rows.add(const CircularProgressIndicator(
              value: null,
            ));
          } else {
            CoinMarketInfo? coinMarketInfo = snapshot.data;
            if (coinMarketInfo != null) {
              List<MarketField> marketFields = [
                MarketField(
                    "Market cap rank", "#${coinMarketInfo.marketCapRank}"),
                MarketField("Market cap",
                    currencyFormatter.format(coinMarketInfo.marketCap)),
                MarketField("Trading volume",
                    currencyFormatter.format(coinMarketInfo.tradingVolume24h)),
                MarketField("Circulating supply",
                    currencyFormatter.format(coinMarketInfo.circulatingSupply)),
                MarketField("Total supply",
                    currencyFormatter.format(coinMarketInfo.totalSupply)),
                MarketField("Max supply",
                    currencyFormatter.format(coinMarketInfo.maxSupply)),
              ];

              marketFields.asMap().forEach((index, mf) {
                var row = Row(
                  children: [Text(mf.field), const Spacer(), Text(mf.value)],
                );
                rows.add(row);
                if (index < marketFields.length - 1) {
                  rows.add(const Divider(
                    color: Colors.black12,
                  ));
                }
              });
            }
          }
          return Column(
            children: rows,
          );
        });
  }
}

class MarketField {
  final String field;
  final String value;

  MarketField(this.field, this.value);
}
