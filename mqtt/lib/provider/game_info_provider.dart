import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:mqtt/repository/app_repository.dart';

class GameInfoProvider with ChangeNotifier {
  final _logger = Logger('GameInfoProvider');
  GameInfoProvider() {}

  bool get hasUserUUID => AppRepository.instance.hasUserUUID;

  void scanQRCode() {
    _logger.info('Scanning QR code');
  }
}
