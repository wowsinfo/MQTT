import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mqtt/foundation/app.dart';
import 'package:mqtt/localisation/localisation.dart';
import 'package:mqtt/model/game_player_info.dart';
import 'package:mqtt/model/game_team_info.dart';
import 'package:mqtt/foundation/personal_rating.dart';
import 'package:mqtt/provider/game_info_provider.dart';
import 'package:mqtt/repository/game_repository.dart';
import 'package:mqtt/ui/shared/icons.dart';
import 'package:mqtt/ui/shared/max_width_box.dart';
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
        if (value.hasEnemyTeam) {
          return Row(
            children: [
              renderTeam(true, value.team1, value.team1Info),
              const VerticalDivider(),
              renderTeam(false, value.team2, value.team2Info),
            ],
          );
        } else {
          return Center(
            child: renderTeam(true, value.team1, value.team1Info),
          );
        }
      },
    );
  }

  Widget renderTeam(
    bool myTeam,
    List<GamePlayerInfo> team,
    GameTeamInfo? info,
  ) {
    final rating = info?.rating ?? ShipRatingHolder.unknown();
    final ratingColour = rating.ratingColour;
    return Expanded(
      child: Column(
        children: [
          // fill width
          FractionallySizedBox(
            widthFactor: 1,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(ratingColour),
                // no round corner
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              child: Text(
                rating.commentWithRating(context) ?? '-',
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                  color: ThemeData.estimateBrightnessForColor(ratingColour) ==
                          Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          renderSimpleInfo(
            '${info?.battleString}',
            '${info?.winRateString}',
            '${info?.damageString}',
            ratingColour,
          ),
          const Divider(),
          Wrap(
            alignment: WrapAlignment.center,
            children:
                team.map((player) => renderPlayer(myTeam, player)).toList(),
          ),
        ],
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
    final availableWidth = MediaQuery.of(context).size.width / 2 - 8;
    print('available width: $availableWidth');
    final maxItemPerRow = max(1, (availableWidth / 200).floor());
    print(maxItemPerRow);
    final itemWidth = availableWidth / maxItemPerRow;
    print(itemWidth);

    final playerRating = ShipRatingHolder.fromNumber(player.pvp?.pr);
    print(playerRating.rating);
    final playerRatingColour = playerRating.ratingColour;
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: MaxWidthBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      player.fullPlayerName ?? '-',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          playerRatingColour,
                        ),
                        // no round corner
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      child: Text(
                        playerRating.commentWithRating(context) ?? '-',
                        style: TextStyle(
                          color: ThemeData.estimateBrightnessForColor(
                                      playerRatingColour) ==
                                  Brightness.light
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: renderSimpleInfo(
                      '${player.battleString}',
                      '${player.winString}',
                      '${player.damageString}',
                      playerRatingColour,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: SizedBox(
        width: itemWidth,
        child: Column(
          children: [
            // mirror this image based on myTeam
            Transform.scale(
              scaleX: myTeam ? 1 : -1,
              child: Image.asset('assets/ships/$shipIndex.png'),
            ),
            Text(
              shipTitle,
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                player.patchedFullname ?? '-',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: playerRatingColour,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            renderSimpleInfo(
              '${player.shipBattleString}',
              '${player.shipWinString}',
              '${player.shipDamageString}',
              ratingColour,
            ),
            Container(
              height: 16,
              color: ratingColour,
            )
          ],
        ),
      ),
    );
  }

  Widget renderSimpleInfo(
    String battle,
    String win,
    String damage,
    Color ratingColour,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        iconWithText(
          battleIcon,
          battle,
          ratingColour,
        ),
        iconWithText(
          winrateIcon,
          win,
          ratingColour,
        ),
        iconWithText(
          damageIcon,
          damage,
          ratingColour,
        ),
      ],
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
