import 'package:flutter/foundation.dart';

@immutable
class GameMapInfo {
  const GameMapInfo({
    this.matchGroup,
    this.mapId,
    this.userCount,
    this.gameType,
    this.dateTime,
  });

  final String? matchGroup;
  final int? mapId;
  final int? userCount;
  final String? gameType;
  final String? dateTime;

  factory GameMapInfo.fromJson(Map<String, dynamic> json) => GameMapInfo(
        matchGroup: json['matchGroup'],
        mapId: json['mapId'],
        userCount: json['userCount'],
        gameType: json['gameType'],
        dateTime: json['dateTime'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameMapInfo &&
          runtimeType == other.runtimeType &&
          matchGroup == other.matchGroup &&
          mapId == other.mapId &&
          userCount == other.userCount &&
          gameType == other.gameType &&
          dateTime == other.dateTime;

  @override
  int get hashCode => dateTime.hashCode;
}
