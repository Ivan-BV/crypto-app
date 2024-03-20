import 'package:cryptoapp/src/pages/coin_data/coin_details.dart';
import 'package:cryptoapp/src/cfg/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoinListItem extends StatelessWidget {
  const CoinListItem({super.key, required this.coin});
  final Coin coin;

  @override
  Widget build(BuildContext context) {
    bool isUp = coin.priceChange24Percentage >= 0;
    return Card(
      elevation: 4,
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 20, color: Colors.black87),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CoinDetails(coin: coin)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 30,
                    child: Image.network(coin.imageUrl),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coin.name,
                    ),
                    Text(coin.symbol)
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(NumberFormat.simpleCurrency(locale: 'es')
                        .format(coin.priceVsEur)),
                    Text(
                      "${NumberFormat('####.##').format(coin.priceChange24Percentage)}%",
                      style: TextStyle(
                          color: isUp ? Colors.green : Colors.red,
                          fontSize: 18),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
