import 'package:flutter/material.dart';
import 'package:mqtt/foundation/app.dart';
import 'package:mqtt/localisation/localisation.dart';
import 'package:mqtt/model/game_player_info.dart';
import 'package:mqtt/model/personal_rating.dart';
import 'package:mqtt/provider/game_info_provider.dart';
import 'package:mqtt/repository/game_repository.dart';
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
      value: _provider,
      child: renderContent(),
    );
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
        children: team.map((player) => renderPlayer(myTeam, player)).toList(),
      ),
    );
  }

  Widget renderPlayer(bool myTeam, GamePlayerInfo player) {
    final shipID = player.shipId.toString();
    final shipInfo = GameRepository.instance.getShipInfo(shipID);

    final shipIndex = shipInfo?.index;
    final currLang = Localizations.localeOf(context).languageCode;
    final shipName = GameRepository.instance.getShipName(shipID, currLang);
    final shipTier = shipInfo?.tierString;
    final shipTitle = '$shipTier $shipName';

    final rating = PersonalRating.rateSingle(player);
    final ratingColour = rating.ratingColour;
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          // mirror this image based on myTeam
          Transform.scale(
            scaleX: myTeam ? 1 : -1,
            child: Image.asset('assets/ships/$shipIndex.png'),
          ),
          Text(shipTitle),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              player.userName ?? '-',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Theme(
            data: ThemeData(primaryColor: ratingColour),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                iconWithText(
                  battleIcon,
                  '${player.shipBattleString}',
                  ratingColour,
                ),
                iconWithText(
                  winrateIcon,
                  '${player.shipWinString}',
                  ratingColour,
                ),
                iconWithText(
                  damageIcon,
                  '${player.shipDamageString}',
                  ratingColour,
                ),
              ],
            ),
          ),
          Container(
            height: 16,
            color: ratingColour,
          )
        ],
      ),
    );
  }

  Widget iconWithText(AssetImage icon, String text, Color color) {
    return Column(
      children: [
        Image(
          image: icon,
          width: 24,
          height: 24,
          color: color,
        ),
        Text(text),
      ],
    );
  }
}
