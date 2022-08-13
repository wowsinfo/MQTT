import 'dart:async';

import 'package:logging/logging.dart';
import 'package:mqtt/foundation/mqtt_client.dart';
import 'package:mqtt/repository/app_repository.dart';
import 'package:mqtt/service/file_service.dart';
import 'package:uuid/uuid.dart';

class PublishService {
  final _logger = Logger('PublishService');
  PublishService({this.cycle = 10, required this.fileService});

  final int cycle;
  final FileService? fileService;
  WWSClient? _client;
  Timer? _timer;

  Future<void> _publishIfNeeded() async {
    if (fileService == null) {
      stop();
      return;
    }

    final success = await fileService?.load(cycle: Duration(seconds: cycle));
    if (success == null) {
      _logger.severe('critical error');
      return;
    }

    if (!success) {
      _logger.info('No need to publish');
      return;
    }

    _logger.fine('Publishing');
    if (_client == null) {
      const uuid = Uuid();
      final userId = fileService?.userID;
      if (userId == null) {
        _logger.severe('userID is null');
        return;
      }

      final server = AppRepository.instance.gameServer;
      if (server == null) {
        _logger.severe('server is null');
        return;
      }

      _client = WWSClient(
        clientID: uuid.v4(),
        userID: userId,
      );

      await _client?.initialise();
      await _client?.pushServer(server);
    }

    final gameInfo = fileService?.json;
    if (gameInfo == null) {
      _logger.severe('tempArena is invalid');
      return;
    }

    await _client?.pushBattleInfo(gameInfo);
  }

  void start() {
    // prevent potential leaks
    if (_timer != null) stop();

    // keep the service running per 10 seconds
    _publishIfNeeded();
    _timer = Timer.periodic(Duration(seconds: cycle), (_) {
      _publishIfNeeded();
    });
    _logger.info('Started the service');
  }

  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;

    final success = await _client?.disconnect();
    assert(success == true, 'mqtt client failed to disconnect');
    _client = null;
    _logger.info('Stopped the service');
  }
}
