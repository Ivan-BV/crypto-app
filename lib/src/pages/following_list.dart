import 'package:cryptoapp/src/cfg/follow_state_provider.dart';
import 'package:cryptoapp/src/cfg/api_client.dart';
import 'package:cryptoapp/src/pages/coin_data/coin_list_item.dart';
import 'package:cryptoapp/src/cfg/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class FollowingCoinsScreen extends StatelessWidget {
  const FollowingCoinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FollowState>(
      builder: ((context, appState, child) {
        return FutureBuilder<List<Coin>>(
            future: getFollowedCoins(appState),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child: CircularProgressIndicator(
                  value: null,
                ));
              }
              List<Coin>? coins = snapshot.data;
              if (coins == null) {
                return const Text(
                    "Something happend wrong while loading list coins");
              } else {
                if (coins.isEmpty) {
                  return const Center(
                    child: Text("Doesn't have following coins"),
                  );
                }
                return ListView.builder(
                  itemCount: coins.length,
                  itemBuilder: ((context, index) {
                    return CoinRow(
                      coin: coins[index],
                    );
                  }),
                );
              }
            });
      }),
    );
  }

  Future<List<Coin>> getFollowedCoins(FollowState appState) async {
    var coinsIds = appState.followedCoinsIds;

    return ApiClient().getCoins(coinsIds);
  }
}

class CoinRow extends StatelessWidget {
  final Coin coin;

  const CoinRow({super.key, required this.coin});

  @override
  Widget build(BuildContext context) {
    return Slidable(
        endActionPane: ActionPane(motion: ScrollMotion(), children: [
          SlidableAction(
            onPressed: (context) {
              onUnFollowingCoin(context, coin.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Unfollowed ${coin.name}"),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.black,
            icon: Icons.favorite,
            label: 'Unfollow coin',
          )
        ]),
        child: CoinListItem(
          coin: coin,
        ));
  }

  void onUnFollowingCoin(BuildContext context, String coinId) {
    var appState = Provider.of<FollowState>(context, listen: false);
    appState.remove(coinId);
  }
}
