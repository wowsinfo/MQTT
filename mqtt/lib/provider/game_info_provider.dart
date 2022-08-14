import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:mqtt/model/game_map_info.dart';
import 'package:mqtt/model/game_player_info.dart';
import 'package:mqtt/repository/app_repository.dart';
import 'package:mqtt/service/subscribe_service.dart';
import 'package:mqtt/ui/qr_scanner_page.dart';
import 'package:mqtt/ui/shared/alert.dart';

class GameInfoProvider with ChangeNotifier {
  final _logger = Logger('GameInfoProvider');
  SubscribeService? _service;
  GameInfoProvider() {
    if (hasUserUUID) {
      _logger.fine('has user uuid');
      _subscribe();
    }
  }

  @override
  void dispose() {
    _service?.stop();
    _service = null;
    super.dispose();
  }

  bool get hasUserUUID => AppRepository.instance.hasUserUUID;
  bool _subscribed = false;

  bool _hasData = false;
  bool get hasData => _hasData;

  GameMapInfo? _mapInfo;
  int _counter = 0;

  /// The user's team
  List<GamePlayerInfo> get team1 => _team1.toList();
  final Set<GamePlayerInfo> _team1 = {};

  /// The other team
  List<GamePlayerInfo> get team2 => _team2.toList();
  final Set<GamePlayerInfo> _team2 = {};

  void scanQRCode(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QRScannerPage(
          onQRCodeScanned: (code) {
            if (code.length == 36) {
              _logger.info('Scanned QR code: $code');
              AppRepository.instance.userUUID = code;
              _subscribe();
            } else {
              showErrorAlert(context, message: 'Invalid QR code');
            }
          },
        ),
      ),
    );
  }

  void _subscribe() {
    if (_subscribed || _service != null) return;
    _service ??= SubscribeService(userID: AppRepository.instance.userUUID!);
    _service?.start(_onMessage);
    _subscribed = true;
    notifyListeners();
    _logger.info('Subscribing');
  }

  void _onMessage(String message) {
    _logger.info('Received message: $message');
    final json = jsonDecode(message) as Map<String, dynamic>;
    if (json.containsKey('userName')) {
      final userCount = _mapInfo?.userCount;
      if (userCount == null || userCount == 0 || _counter == 0) {
        assert(false, 'Game information is unknown, ignoring...');
        return;
      }

      final playerInfo = GamePlayerInfo.fromJson(json);
      final myTeam = playerInfo.myTeam;
      if (myTeam == null) {
        assert(false, 'My team is unknown, ignoring...');
        return;
      }

      if (myTeam) {
        _team1.add(playerInfo);
      } else {
        _team2.add(playerInfo);
      }
      _counter += 1;

      if (userCount == _counter) {
        // all players have been received
        _hasData = true;
        notifyListeners();
      }
    } else {
      final mapInfo = GameMapInfo.fromJson(json);
      if (_mapInfo == mapInfo) {
        _logger.info('Same map info, ignoring...');
        return;
      }

      _mapInfo = mapInfo;
      final userCount = mapInfo.userCount;
      if (userCount == null || userCount == 0) {
        assert(false, 'userCount is null or 0');
        return;
      }

      // reset last game info
      _counter = userCount;
      _team1.clear();
      _team2.clear();
      _hasData = false;
      notifyListeners();
    }
  }
}
