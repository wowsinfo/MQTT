import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mqtt/model/game_map_info.dart';
import 'package:mqtt/model/game_player_info.dart';
import 'package:mqtt/model/temp_arena_info.dart';

import 'test_data_loader.dart';

void main() {
  test('test GamePlayerInfo equality', () {
    const json =
        '{"myTeam":true,"hide":false,"accountId":2033041256,"userName":"mko4","clanTag":"WOWMK","clanColor":"#b3b3b3","pvp":{"pr":1238,"battles":4452,"wins":52.11,"damage":47950,"xp":1485,"kd":1.02,"hit":34.77,"frags":0.71},"ship":{"pr":0,"battles":0,"wins":0.0,"damage":0,"xp":0,"kd":0.0,"hit":0.0,"frags":0.0}}';

    final player1 =
        GamePlayerInfo.fromJson(jsonDecode(json) as Map<String, dynamic>);
    final player2 =
        GamePlayerInfo.fromJson(jsonDecode(json) as Map<String, dynamic>);
    expect(player1 == player2, true);

    const json2 =
        '{"myTeam":true,"hide":false,"accountId":2033041256,"userName":"henry","clanTag":"WOWMK","clanColor":"#b3b3b3","pvp":{"pr":1238,"battles":4452,"wins":52.11,"damage":47950,"xp":1485,"kd":1.02,"hit":34.77,"frags":0.71},"ship":{"pr":0,"battles":0,"wins":0.0,"damage":0,"xp":0,"kd":0.0,"hit":0.0,"frags":0.0}}';
    final player3 =
        GamePlayerInfo.fromJson(jsonDecode(json2) as Map<String, dynamic>);
    expect(player1 == player3, false);
  });

  test('test GamePlayerInfo set addition', () {
    final Set<GamePlayerInfo> team = {};
    const json =
        '{"myTeam":true,"hide":false,"accountId":2033041256,"userName":"mko4","clanTag":"WOWMK","clanColor":"#b3b3b3","pvp":{"pr":1238,"battles":4452,"wins":52.11,"damage":47950,"xp":1485,"kd":1.02,"hit":34.77,"frags":0.71},"ship":{"pr":0,"battles":0,"wins":0.0,"damage":0,"xp":0,"kd":0.0,"hit":0.0,"frags":0.0}}';
    final player1 =
        GamePlayerInfo.fromJson(jsonDecode(json) as Map<String, dynamic>);
    team.add(player1);
    expect(team.length, 1);
    final player2 =
        GamePlayerInfo.fromJson(jsonDecode(json) as Map<String, dynamic>);
    team.add(player2);
    expect(team.length, 1);
    const json2 =
        '{"myTeam":true,"hide":false,"accountId":2033041256,"userName":"henry","clanTag":"WOWMK","clanColor":"#b3b3b3","pvp":{"pr":1238,"battles":4452,"wins":52.11,"damage":47950,"xp":1485,"kd":1.02,"hit":34.77,"frags":0.71},"ship":{"pr":0,"battles":0,"wins":0.0,"damage":0,"xp":0,"kd":0.0,"hit":0.0,"frags":0.0}}';
    final player3 =
        GamePlayerInfo.fromJson(jsonDecode(json2) as Map<String, dynamic>);
    team.add(player3);
    expect(team.length, 2);
  });

  test('test GameMapInfo equality', () {
    const json =
        '{"matchGroup":"WOWMK","mapId":1,"userCount":2,"gameType":"pve","dateTime":"2020-01-01T00:00:00.000Z"}';
    final map1 = GameMapInfo.fromJson(jsonDecode(json) as Map<String, dynamic>);
    final map2 = GameMapInfo.fromJson(jsonDecode(json) as Map<String, dynamic>);
    expect(map1 == map2, true);
    const json2 =
        '{"matchGroup":"WOWMK","mapId":1,"userCount":2,"gameType":"pve","dateTime":"2020-01-01T01:00:00.000Z"}';
    final map3 =
        GameMapInfo.fromJson(jsonDecode(json2) as Map<String, dynamic>);
    expect(map1 == map3, false);
  });

  test('test loading tempArenaInfo.json', () async {
    final loader = TestDataLoader();
    final testData = await loader.loadTestJson();

    final decoded = TempArenaInfo.fromJson(jsonDecode(testData));
    expect(decoded.vehicles.isNotEmpty, isTrue);
  });
}
