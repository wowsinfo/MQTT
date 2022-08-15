import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:mqtt/model/game_map_info.dart';
import 'package:mqtt/model/game_player_info.dart';

class GameDataManager {
  final _logger = Logger('GameDataManager');
  bool _hasData = false;
  bool get hasData => _hasData;

  GameMapInfo? _mapInfo;
  int _counter = 0;

  /// The user's team
  List<GamePlayerInfo> get team1 => _team1.toList();
  Set<GamePlayerInfo> _team1 = {};

  /// The other team
  List<GamePlayerInfo> get team2 => _team2.toList();
  Set<GamePlayerInfo> _team2 = {};

  int get totalPlayers => team1.length + team2.length;
  bool get hasEnemyTeam => team2.isNotEmpty;

  bool update(String message) {
    _logger.fine('Updating game data: $message');
    final json = jsonDecode(message) as Map<String, dynamic>;
    if (json.containsKey('userName')) {
      final userCount = _mapInfo?.userCount;
      if (userCount == null || userCount == 0) {
        _logger.info(false, 'Game information is unknown, ignoring...');
        return false;
      }

      final playerInfo = GamePlayerInfo.fromJson(json);
      final myTeam = playerInfo.myTeam;
      if (myTeam == null) {
        assert(false, 'My team is unknown, ignoring...');
        return false;
      }

      if (myTeam) {
        _team1.add(playerInfo);
      } else {
        _team2.add(playerInfo);
      }
      _counter += 1;

      if (userCount == _counter) {
        // all players have been received
        _sortTeams();
        _hasData = true;
      }
    } else {
      final mapInfo = GameMapInfo.fromJson(json);
      if (_mapInfo == mapInfo) {
        _logger.info('Same map info, ignoring...');
        return false;
      }

      _mapInfo = mapInfo;
      final userCount = mapInfo.userCount;
      if (userCount == null || userCount == 0) {
        assert(false, 'userCount is null or 0');
        return false;
      }
      _team1.clear();
      _team2.clear();
      _hasData = false;
    }

    return true;
  }

  void _sortTeams() {
    final sortedTeam1 = _team1.toList()..sort((a, b) => a.compare(b));
    _team1 = sortedTeam1.toSet();
    final sortedTeam2 = _team2.toList()..sort((a, b) => a.compare(b));
    _team2 = sortedTeam2.toSet();
  }

  void test() {
    _hasData = true;
    _team1.add(testData1);
    _team1.add(testData2);
    _team2.add(testData2);
    _team2.add(testData1);
  }
}
