import 'package:flutter/foundation.dart';

@immutable
class GamePlayerInfo {
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
}

@immutable
class Pvp {
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
}