import 'package:cryptoapp/src/cfg/follow_state_provider.dart';
import 'package:cryptoapp/src/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FollowState(),
      child: MaterialApp(
        themeMode: ThemeMode.system,
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const Home(title: 'Crypto App'),
      ),
    );
  }
}
