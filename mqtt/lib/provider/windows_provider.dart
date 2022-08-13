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

  void _setup() async {
    if (hasValidPath && hasValidServer) {
      if (_publishService != null) {
        await _publishService?.stop();
        _publishService = null;
      }

      _fileService = FileService(path: AppRepository.instance.replayFolder);
      _publishService = PublishService(fileService: _fileService);
      _logger.info('Setting up services');
      _publishService?.start();
    }
  }

  void showSettings(BuildContext context) {
    showSettingsPopup(context);
  }

  void showReplayFolder() {
    final folder = AppRepository.instance.replayFolder;
    if (folder == null) return;
    launchUrlString('file://$folder');
  }

  void reload() {
    _setup(); // again
  }
}
