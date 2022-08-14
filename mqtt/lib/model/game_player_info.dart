import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';

final testData1 = GamePlayerInfo.fromJson(jsonDecode(
    '{"myTeam":false,"hide":true,"accountId":-1,"userName":":Zavoyko:","clanTag":null,"clanColor":null,"pvp":null,"ship":null}'));
final testData2 = GamePlayerInfo.fromJson(jsonDecode(
    '{"myTeam":true,"hide":false,"accountId":2011774448,"userName":"HenryQuan","clanTag":"ICBC","clanColor":"#cc9966","pvp":{"pr":1353,"battles":4966,"wins":53.99,"damage":42598,"xp":1083,"kd":1.42,"hit":28.38,"frags":0.79},"ship":{"pr":2003,"battles":5,"wins":20.0,"damage":30932,"xp":809,"kd":1.67,"hit":37.21,"frags":1.0}}'));

@immutable
class GamePlayerInfo extends Equatable {
  const GamePlayerInfo({
    this.myTeam,
    this.hide,
    this.accountId,
    this.userName,
    this.clanTag,
    this.clanColor,
    this.pvp,
    this.ship,
  });

  final bool? myTeam;
  final bool? hide;
  final int? accountId;
  final String? userName;
  final String? clanTag;
  final String? clanColor;
  final Pvp? pvp;
  final Pvp? ship;

  String? get formattedClanTag => clanTag == null ? null : '[$clanTag]';

  factory GamePlayerInfo.fromJson(Map<String, dynamic> json) => GamePlayerInfo(
        myTeam: json['myTeam'],
        hide: json['hide'],
        accountId: json['accountId'],
        userName: json['userName'],
        clanTag: json['clanTag'],
        clanColor: json['clanColor'],
        pvp: json['pvp'] == null ? null : Pvp.fromJson(json['pvp']),
        ship: json['ship'] == null ? null : Pvp.fromJson(json['ship']),
      );

  @override
  List<Object?> get props =>
      [myTeam, hide, accountId, userName, clanTag, clanColor, pvp, ship];
}

@immutable
class Pvp extends Equatable {
  const Pvp({
    this.pr,
    this.battles,
    this.wins,
    this.damage,
    this.xp,
    this.kd,
    this.hit,
    this.frags,
  });

  final int? pr;
  final int? battles;
  final double? wins;
  final int? damage;
  final int? xp;
  final double? kd;
  final double? hit;
  final double? frags;

  factory Pvp.fromJson(Map<String, dynamic> json) => Pvp(
        pr: json['pr'],
        battles: json['battles'],
        wins: json['wins'],
        damage: json['damage'],
        xp: json['xp'],
        kd: json['kd'],
        hit: json['hit'],
        frags: json['frags'],
      );

  @override
  // TODO: implement props
  List<Object?> get props => [pr, battles, wins, damage, xp, kd, hit, frags];
}
