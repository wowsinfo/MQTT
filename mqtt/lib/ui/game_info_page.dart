import 'package:flutter/material.dart';
import 'package:mqtt/provider/game_info_provider.dart';

/// Embed this widget in a container like [Scaffold] to display the game info.
class GameInfoPage extends StatefulWidget {
  const GameInfoPage({Key? key}) : super(key: key);

  @override
  State<GameInfoPage> createState() => _GameInfoPageState();
}

class _GameInfoPageState extends State<GameInfoPage> {
  final _provider = GameInfoProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Info'),
      ),
      body: Center(
        child: Text('Game Info'),
      ),
    );
  }
}
