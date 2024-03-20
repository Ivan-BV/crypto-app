import 'package:cryptoapp/src/cfg/follow_preferences.dart';
import 'package:cryptoapp/src/cfg/follow_state_provider.dart';
import 'package:cryptoapp/src/pages/coins_list.dart';
import 'package:cryptoapp/src/pages/following_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadFollowedCoins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        shadowColor: Colors.black45,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/crypto_icon.png",
              width: 40,
            ),
            const Padding(padding: EdgeInsets.only(right: 0, left: 0)),
            Text(
              widget.title,
              style: const TextStyle(color: Colors.black87),
            )
          ],
        ),
      ),
      body: _selectedIndex == 0 ? CoinsListScreen() : FollowingCoinsScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.currency_bitcoin), label: 'Coins'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline), label: 'Following')
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.green,
      ),
    );
  }

  void loadFollowedCoins() {
    FollowPreferences().retrieveAllCoins().then((coinsList) {
      var appState = Provider.of<FollowState>(context, listen: false);
      appState.followedCoinsIds = coinsList;
    });
  }
}
