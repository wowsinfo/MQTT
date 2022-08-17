import 'package:mqtt/extensions/number.dart';
import 'package:mqtt/model/game_player_info.dart';
import 'package:mqtt/foundation/personal_rating.dart';

class GameTeamInfo with Calculation {
  GameTeamInfo({
    required this.players,
  });

  final List<GamePlayerInfo> players;

  double _battles = 0;
  double _frags = 0;
  double _wins = 0;
  double _damage = 0;

  String get battleString => _battles.toFixedString(0);
  String get winRateString => _wins.toPercentString();
  String get damageString => _damage.floor().toDecimalString();

  late final rating = PersonalRating.rateMultiple(players);

  void overall() {
    _battles = 0;
    _frags = 0;
    _wins = 0;
    _damage = 0;

    for (final player in players) {
      final currBattle = player.ship?.battles;
      if (currBattle == null || currBattle == 0) continue;
      _battles += currBattle.toDouble();
      _frags += multiply(player.ship?.frags, currBattle) ?? 0;
      _wins += multiply(player.ship?.wins, currBattle / 100) ?? 0;
      _damage += multiply(player.ship?.damage, currBattle) ?? 0;
    }

    _frags /= _battles;
    _wins /= _battles;
    _damage /= _battles;
  }
}
