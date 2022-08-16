import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mqtt/extensions/number.dart';
import 'package:mqtt/localisation/localisation.dart';
import 'package:mqtt/repository/game_repository.dart';

abstract class Ratable {
  /// It is in the percentage form (56.3213 not 0.563213)
  double? get averageWinrate;
  double? get averageFrag;
  double? get averageDamage;

  String? get shipID;
  double? get totalBattle;
}

mixin Calculation {
  num? divide(num? a, num? b) {
    if (a == null || b == null) {
      return null;
    }
    return a / b;
  }

  num? multiply(num? a, num? b) {
    if (a == null || b == null) {
      return null;
    }
    return a * b;
  }
}

enum ShipRating {
  unknown,
  bad,
  belowAverage,
  average,
  good,
  veryGood,
  great,
  unicum,
  superUnicum;

  static ShipRating fromNumber(num? value) {
    if (value == null || value == 0) return ShipRating.unknown;
    if (value < 750) return ShipRating.bad;
    if (value < 1100) return ShipRating.belowAverage;
    if (value < 1350) return ShipRating.average;
    if (value < 1550) return ShipRating.good;
    if (value < 1750) return ShipRating.veryGood;
    if (value < 2100) return ShipRating.great;
    if (value < 2450) return ShipRating.unicum;
    return ShipRating.superUnicum;
  }

  String? comment(BuildContext context) {
    switch (this) {
      case ShipRating.unknown:
        return Localisation.of(context).rating_unknown;
      case ShipRating.bad:
        return Localisation.of(context).rating_bad;
      case ShipRating.belowAverage:
        return Localisation.of(context).rating_below_average;
      case ShipRating.average:
        return Localisation.of(context).rating_average;
      case ShipRating.good:
        return Localisation.of(context).rating_good;
      case ShipRating.veryGood:
        return Localisation.of(context).rating_very_good;
      case ShipRating.great:
        return Localisation.of(context).rating_great;
      case ShipRating.unicum:
        return Localisation.of(context).rating_unicum;
      case ShipRating.superUnicum:
        return Localisation.of(context).rating_super_unicum;
      default:
        return null;
    }
  }

  Color ratingColour() {
    switch (this) {
      case ShipRating.unknown:
        return Colors.blueGrey;
      case ShipRating.bad:
        return Colors.red;
      case ShipRating.belowAverage:
        return Colors.orange;
      case ShipRating.average:
        return Colors.amber;
      case ShipRating.good:
        return Colors.lightGreen;
      case ShipRating.veryGood:
        return Colors.green;
      case ShipRating.great:
        return Colors.cyan;
      case ShipRating.unicum:
        return Colors.purple;
      case ShipRating.superUnicum:
        return Colors.deepPurple;
      default:
        return Colors.blueGrey;
    }
  }
}

@immutable
class ShipRatingHolder {
  final num rating;
  final ShipRating shipRating;

  const ShipRatingHolder({
    required this.rating,
    required this.shipRating,
  });

  static ShipRatingHolder unknown() => const ShipRatingHolder(
        rating: 0,
        shipRating: ShipRating.unknown,
      );

  String get ratingValueString => rating.toFixedString(0);
  String? localisedComment(BuildContext context) => shipRating.comment(context);

  String? commentWithRating(BuildContext context) {
    final comment = localisedComment(context);
    if (comment == null) return null;
    return '$comment - $ratingValueString';
  }

  Color get ratingColour => shipRating.ratingColour();

  @override
  String toString() => '$rating $shipRating';
}

class PersonalRating {
  static ShipRatingHolder rateSingle(Ratable? item) {
    if (item == null) return ShipRatingHolder.unknown();
    final battles = item.totalBattle;
    if (battles == null || battles == 0) return ShipRatingHolder.unknown();

    final actualDamage = (item.averageDamage ?? 0) * battles;
    final actualFrag = (item.averageFrag ?? 0) * battles;
    final actualWinrate = (item.averageWinrate ?? 0) * battles / 100;

    final expected = GameRepository.instance.getPersonalRating(item.shipID);
    if (expected == null) return ShipRatingHolder.unknown();

    final expectedDamage = expected.averageDamageDealt.toDouble() * battles;
    final expectedFrag = expected.averageFrags * battles;
    final expectedWinrate = expected.winRate * battles / 100;

    return calculate(
      actualDamage,
      expectedDamage,
      actualFrag,
      expectedFrag,
      actualWinrate,
      expectedWinrate,
    );
  }

  static ShipRatingHolder rateMultiple(List<Ratable?> items) {
    double actualDamage = 0;
    double actualFrag = 0;
    double actualWinrate = 0;

    double expectedDamage = 0;
    double expectedFrag = 0;
    double expectedWinrate = 0;

    for (final item in items) {
      if (item == null) continue;
      final battles = item.totalBattle;
      if (battles == null || battles == 0) continue;
      final expected = GameRepository.instance.getPersonalRating(item.shipID);
      if (expected == null) continue;

      actualDamage += (item.averageDamage ?? 0) * battles;
      actualFrag += (item.averageFrag ?? 0) * battles;
      actualWinrate += (item.averageWinrate ?? 0) * battles / 100;

      expectedDamage += expected.averageDamageDealt.toDouble() * battles;
      expectedFrag += expected.averageFrags * battles;
      expectedWinrate += expected.winRate * battles / 100;
    }

    return calculate(
      actualDamage,
      expectedDamage,
      actualFrag,
      expectedFrag,
      actualWinrate,
      expectedWinrate,
    );
  }

  static ShipRatingHolder calculate(
    double actualDamage,
    double expectedDamage,
    double actualFrag,
    double expectedFrag,
    double actualWinrate,
    double expectedWinrate,
  ) {
    final rDmg = actualDamage / expectedDamage;
    final rWins = actualWinrate / expectedWinrate;
    final rFrags = actualFrag / expectedFrag;

    final nDmg = max(0, (rDmg - 0.4) / (1 - 0.4));
    final nFrags = max(0, (rFrags - 0.1) / (1 - 0.1));
    final nWins = max(0, (rWins - 0.7) / (1 - 0.7));

    final pr = 700 * nDmg + 300 * nFrags + 150 * nWins;
    return ShipRatingHolder(
      rating: pr,
      shipRating: ShipRating.fromNumber(pr),
    );
  }
}
