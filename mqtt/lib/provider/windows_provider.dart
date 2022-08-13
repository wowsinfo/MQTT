import 'package:flutter/material.dart';
import 'package:mqtt/foundation/mqtt_client.dart';
import 'package:mqtt/repository/app_repository.dart';
import 'package:mqtt/ui/shared/settings_popup.dart';

/// The publisher side
class WindowsProvider with ChangeNotifier {
  WindowsProvider() {
    // Check for the tempArenaInfo.json under the replay folder
    // If it exists, then use it as the publish data
    // Otherwise, use the default data
  }

  bool get hasValidPath => AppRepository.instance.replayFolder != null;
  bool get hasValidServer => AppRepository.instance.gameServer != null;

  bool _waiting = true;
  bool get isWaiting => _waiting;

  bool _working = false;
  bool get isWorking => _working;

  void showSettings(BuildContext context) {
    showSettingsPopup(context);
  }
}
