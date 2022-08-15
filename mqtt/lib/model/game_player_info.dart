import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:equatable/equatable.dart';
import 'package:mqtt/extensions/number.dart';
import 'package:mqtt/model/personal_rating.dart';

final testData1 = GamePlayerInfo.fromJson(jsonDecode(
    '{"myTeam":false,"hide":true,"accountId":-1,"shipId":3338548944,"userName":":Zavoyko:","clanTag":null,"clanColor":null,"pvp":null,"ship":null}'));
final testData2 = GamePlayerInfo.fromJson(jsonDecode(
    '{"myTeam":true,"hide":false,"accountId":2011774448,"shipId":4184750032,"userName":"HenryQuan","clanTag":"ICBC","clanColor":"#cc9966","pvp":{"pr":1353,"battles":4966,"wins":53.99,"damage":42598,"xp":1083,"kd":1.42,"hit":28.38,"frags":0.79},"ship":{"pr":2003,"battles":5,"wins":20.0,"damage":30932,"xp":809,"kd":1.67,"hit":37.21,"frags":1.0}}'));

@immutable
class GamePlayerInfo extends Equatable implements Ratable {
  const GamePlayerInfo({
    this.myTeam,
    this.hide,
    this.accountId,
    this.shipId,
    this.userName,
    this.clanTag,
    this.clanColor,
    this.pvp,
    this.ship,
  });

  final bool? myTeam;
  final bool? hide;
  final int? accountId;
  final int? shipId;
  final String? userName;
  final String? clanTag;
  final String? clanColor;
  final Pvp? pvp;
  final Pvp? ship;

  String? get battleString => pvp?.battles?.toDecimalString() ?? '-';
  String? get winString => pvp?.wins?.asPercentString() ?? '-';
  String? get damageString => pvp?.damage?.toDecimalString() ?? '-';

  String? get shipBattleString => ship?.battles?.toDecimalString() ?? '-';
  String? get shipWinString => ship?.wins?.asPercentString() ?? '-';
  String? get shipDamageString => ship?.damage?.toDecimalString() ?? '-';

  String? get formattedClanTag => clanTag == null ? null : '[$clanTag]';

  @override
  double? get averageDamage => ship?.damage?.toDouble();

  @override
  double? get averageFrag => ship?.frags?.toDouble();

  @override
  double? get averageWinrate => ship?.wins?.toDouble();

  @override
  String? get shipID => shipId?.toString();

  @override
  double? get totalBattle => ship?.battles?.toDouble();

  bool get shouldDisplay {
    if (hide == null || hide!) return false;
    if (ship?.battles == 0) return false;
    return true;
  }

  factory GamePlayerInfo.fromJson(Map<String, dynamic> json) => GamePlayerInfo(
        myTeam: json['myTeam'],
        hide: json['hide'],
        accountId: json['accountId'],
        shipId: json['shipId'],
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
  List<Object?> get props => [pr, battles, wins, damage, xp, kd, hit, frags];
}
