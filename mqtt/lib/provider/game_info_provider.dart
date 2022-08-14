import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
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
  }
}
