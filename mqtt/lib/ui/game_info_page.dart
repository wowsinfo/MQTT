import 'package:flutter/material.dart';
import 'package:mqtt/foundation/app.dart';
import 'package:mqtt/provider/game_info_provider.dart';
import 'package:provider/provider.dart';

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
    return ChangeNotifierProvider.value(
        value: _provider, child: renderContent());
  }

  TextButton scanQRButton() {
    return TextButton.icon(
      onPressed: () => _provider.scanQRCode(context),
      icon: const Icon(Icons.qr_code),
      label: const Text('Scan QR'),
    );
  }

  Widget renderContent() {
    return Consumer<GameInfoProvider>(
      builder: (context, value, child) {
        if (!value.hasUserUUID) {
          return Center(child: scanQRButton());
        }

        if (!value.hasData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                // not required for windows
                if (App.isMobile)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: scanQRButton(),
                  ),
              ],
            ),
          );
        }

        return renderGameInfo();
      },
    );
  }

  Widget renderGameInfo() {
    return Consumer<GameInfoProvider>(
      builder: (context, value, child) {
        return Column(
          children: const [],
        );
      },
    );
  }
}
