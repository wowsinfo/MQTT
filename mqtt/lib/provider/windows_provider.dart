import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:mqtt/repository/app_repository.dart';
import 'package:mqtt/service/file_service.dart';
import 'package:mqtt/service/publish_service.dart';
import 'package:mqtt/ui/shared/settings_popup.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// The publisher side
class WindowsProvider with ChangeNotifier {
  final _logger = Logger('WindowsProvider');
  WindowsProvider() {
    _setup();
  }

  FileService? _fileService;
  PublishService? _publishService;

  bool get hasValidPath => AppRepository.instance.replayFolder != null;
  bool get hasValidServer => AppRepository.instance.gameServer != null;

  bool _waiting = true;
  bool get isWaiting => _waiting;

  bool _working = false;
  bool get isWorking => _working;

  void _setup() {
    _fileService = FileService(path: AppRepository.instance.replayFolder);
    _publishService = PublishService(fileService: _fileService);
    _logger.info('Setting up services');
    _publishService?.start();
  }

  void showSettings(BuildContext context) {
    showSettingsPopup(context);
  }

  void showReplayFolder() {
    launchUrlString('file://C:\\Intel');
  }

  void reload() {
    _setup(); // again
  }
}
