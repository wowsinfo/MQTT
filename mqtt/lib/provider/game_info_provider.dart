import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:mqtt/foundation/app.dart';
import 'package:mqtt/localisation/localisation.dart';
import 'package:mqtt/foundation/game_data_manager.dart';
import 'package:mqtt/model/game_player_info.dart';
import 'package:mqtt/model/game_team_info.dart';
import 'package:mqtt/repository/app_repository.dart';
import 'package:mqtt/service/subscribe_service.dart';
import 'package:mqtt/ui/qr_scanner_page.dart';
import 'package:mqtt/ui/shared/alert.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  final screenshotController = ScreenshotController();

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
            if (code.length <= 64) {
              _logger.info('Scanned QR code: $code');
              AppRepository.instance.userUUID = code;
              _subscribe();
              Navigator.of(context).pop();
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

  void shareBattleInfo(BuildContext context) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    // this is not supported on WEB
    final image = await screenshotController.capture(
      delay: const Duration(milliseconds: 10),
    );

    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = await File('${directory.path}/battle.jpg').create();
      await imagePath.writeAsBytes(image);
      if (App.isDesktop) {
        await launchUrlString('file://${directory.path}');
      } else {
        await Share.shareFiles([imagePath.path]);
      }
    }
  }

  void _test() {
    _subscribed = true;
    _dataManager.test();
    notifyListeners();
  }

  void _subscribe() {
    if (_subscribed || _service != null) {
      _service?.stop();
      _service = null;
      _logger.info('Stopped previous subscription');
    }
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
