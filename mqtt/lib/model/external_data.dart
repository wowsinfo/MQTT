import 'package:flutter/foundation.dart';

@immutable
class PrInfo {
  const PrInfo({
    required this.time,
    required this.data,
  });

  final int time;
  final Map<String, PRShipInfo> data;

  factory PrInfo.fromJson(Map<String, dynamic> json) {
    // remove empty values
    final rawData = json['data'] as Map<String, dynamic>;
    final List<String> keysToRemove = [];
    for (final entry in rawData.entries) {
      final value = entry.value;
      if (value is List && value.isEmpty) {
        keysToRemove.add(entry.key);
      }
    }

    for (final entry in keysToRemove) {
      rawData.remove(entry);
    }

    return PrInfo(
      time: json['time'],
      data: Map.from(json['data']).map(
        (k, v) => MapEntry<String, PRShipInfo>(k, PRShipInfo.fromJson(v)),
      ),
    );
  }
}

const List<String> _tiers = [
  'I',
  'II',
  'III',
  'IV',
  'V',
  'VI',
  'VII',
  'VIII',
  'IX',
  'X',
  '★',
  '★',
];

@immutable
class PRShipInfo {
  const PRShipInfo({
    required this.averageDamageDealt,
    required this.averageFrags,
    required this.winRate,
  });

  final num averageDamageDealt;
  final double averageFrags;
  final double winRate;

  factory PRShipInfo.fromJson(Map<String, dynamic> json) => PRShipInfo(
        averageDamageDealt: json['average_damage_dealt'],
        averageFrags: json['average_frags'],
        winRate: json['win_rate'],
      );
}

@immutable
class ShipIndexInfo {
  const ShipIndexInfo({
    required this.index,
    required this.tier,
  });

  final String index;
  final int tier;

  String get tierString => _tiers[tier - 1];

  factory ShipIndexInfo.fromJson(Map<String, dynamic> json) => ShipIndexInfo(
        index: json['index'],
        tier: json['tier'],
      );
}
