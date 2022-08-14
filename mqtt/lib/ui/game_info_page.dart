import 'package:flutter/material.dart';
import 'package:mqtt/foundation/app.dart';
import 'package:mqtt/localisation/localisation.dart';
import 'package:mqtt/model/game_player_info.dart';
import 'package:mqtt/provider/game_info_provider.dart';
import 'package:mqtt/ui/shared/icons.dart';
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
      label: Text(Localisation.of(context).scan_qr),
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

        return SingleChildScrollView(
          child: renderGameInfo(),
        );
      },
    );
  }

  Widget renderGameInfo() {
    return Consumer<GameInfoProvider>(
      builder: (context, value, child) {
        return Row(
          children: [
            renderTeam(true, value.team1),
            const VerticalDivider(),
            renderTeam(false, value.team2),
          ],
        );
      },
    );
  }

  Widget renderTeam(bool myTeam, List<GamePlayerInfo> team) {
    return Expanded(
      child: Wrap(
        children: team.map((player) => renderPlayer(player)).toList(),
      ),
    );
  }

  Widget renderPlayer(GamePlayerInfo player) {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          Text(player.userName ?? '-'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              iconWithText(battleIcon, '${player.shipBattleString}'),
              iconWithText(winrateIcon, '${player.shipWinString}'),
              iconWithText(damageIcon, '${player.shipDamageString}'),
            ],
          )
        ],
      ),
    );
  }

  Widget iconWithText(AssetImage icon, String text) {
    return Column(
      children: [
        Image(
          image: icon,
          width: 24,
          height: 24,
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
