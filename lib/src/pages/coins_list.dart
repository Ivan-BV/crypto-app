import 'package:cryptoapp/src/cfg/follow_state_provider.dart';
import 'package:cryptoapp/src/cfg/api_client.dart';
import 'package:cryptoapp/src/pages/coin_data/coin_list_item.dart';
import 'package:cryptoapp/src/cfg/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class CoinsListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CoinsListScreenState();
}

class _CoinsListScreenState extends State<CoinsListScreen> {
  final List<String> _coins = [
    "bitcoin",
    "ethereum",
    "solana",
    "algorand",
    "dogecoin",
    "worldcoin",
    "cardano",
    "leo-token",
    "fantom",
  ];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Coin>>(
        future: ApiClient().getCoins(_coins),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator(
              value: null,
            ));
          }
          List<Coin>? coin = snapshot.data;
          if (coin == null) {
            return const Text(
                "Something happend wrong while loading list coins");
          } else {
            return ListView.builder(
                itemCount: _coins.length,
                itemBuilder: ((context, index) {
                  return CoinRow(
                    coin: coin[index],
                  );
                }));
          }
        });
  }
}

class CoinRow extends StatelessWidget {
  final Coin coin;
  const CoinRow({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Slidable(
        endActionPane: ActionPane(motion: const ScrollMotion(), children: [
          SlidableAction(
            onPressed: (context) {
              onFollowingCoin(context, coin.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Following ${coin.name}"),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.black,
            icon: Icons.favorite,
            label: 'Follow coin',
          )
        ]),
        child: CoinListItem(
          coin: coin,
        ));
  }

  void onFollowingCoin(BuildContext context, String coinId) {
    var appState = Provider.of<FollowState>(context, listen: false);
    appState.add(coinId);
  }
}
