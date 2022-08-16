import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:mqtt/localisation/localisation.dart';
import 'package:mqtt/model/game_data_manager.dart';
import 'package:mqtt/model/game_player_info.dart';
import 'package:mqtt/model/game_team_info.dart';
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
      // _test();
      _subscribe();
    }
  }

  @override
  void dispose() {
    _service?.stop();
    _service = null;
    super.dispose();
  }

  final _dataManager = GameDataManager();

  bool get hasUserUUID => AppRepository.instance.hasUserUUID;
  bool _subscribed = false;

  bool get hasData => _dataManager.hasData;

  /// The user's team
  List<GamePlayerInfo> get team1 => _dataManager.team1;
  GameTeamInfo? get team1Info => _dataManager.team1Info;

  /// The other team
  List<GamePlayerInfo> get team2 => _dataManager.team2;
  GameTeamInfo? get team2Info => _dataManager.team2Info;
  bool get hasEnemyTeam => _dataManager.hasEnemyTeam;

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
              showErrorAlert(
                context,
                message: Localisation.of(context).error_invalid_qr_code,
              );
            }
          },
        ),
      ),
    );
  }

  void _test() {
    _subscribed = true;
    _dataManager.test();
    notifyListeners();
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
    final success = _dataManager.update(message);
    print('updated data: $success');
    if (success) notifyListeners();
  }
}
