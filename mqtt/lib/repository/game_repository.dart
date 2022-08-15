import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:logging/logging.dart';
import 'package:mqtt/model/external_data.dart';

class GameRepository {
  static final GameRepository instance = GameRepository._init();
  GameRepository._init();

  bool _initialised = false;
  final _logger = Logger('GameRepository');

  late final PrInfo _personalRating;
  PrInfo get personalRating => _personalRating;

  late final Map<String, ShipIndexInfo> _shipIndex;
  late final Map<String, Map<String, String>> _shipNames;

  Future<void> initialise() async {
    if (_initialised) {
      _logger.severe('GameRepository already initialised');
      throw Exception('GameRepository is already initialised');
    }

    final prJson = await rootBundle.loadString(
      'assets/data/personal_rating.json',
      cache: false,
    );
    final prObject = jsonDecode(prJson);
    _personalRating = PrInfo.fromJson(prObject);

    final shipIndexJson = await rootBundle.loadString(
      'assets/data/ship_index.json',
      cache: false,
    );
    final shipIndexObject = jsonDecode(shipIndexJson);
    _shipIndex = Map.from(shipIndexObject).map((k, v) {
      return MapEntry(k, ShipIndexInfo.fromJson(v));
    });

    final shipNamesJson = await rootBundle.loadString(
      'assets/data/ship_names.json',
      cache: false,
    );
    final shipNamesObject = jsonDecode(shipNamesJson);
    _shipNames = Map.from(shipNamesObject).map((k, v) {
      return MapEntry(k, Map.from(v));
    });

    _initialised = true;
    _logger.info('GameRepository initialised');
  }

  ShipIndexInfo? getShipInfo(String shipId) {
    return _shipIndex[shipId];
  }

  String? getShipName(String shipId, String language) {
    return _shipNames[shipId]?[language];
  }
}
