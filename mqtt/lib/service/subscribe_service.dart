import 'package:logging/logging.dart';
import 'package:mqtt/foundation/mqtt_client.dart';
import 'package:uuid/uuid.dart';

class SubscribeService {
  final _logger = Logger('SubscribeService');
  final String userID;
  SubscribeService({required this.userID});

  final _uuid = const Uuid();
  late final _client = WWSClient(clientID: _uuid.v4(), userID: userID);
  bool _started = false;

  Future<bool> start(MessageCallback callback) async {
    if (_started) return true;

    final success = await _client.initialise();
    if (!success) {
      _logger.severe('critical error');
      return false;
    }

    _started = true;
    _logger.fine('Subscribing');
    await _client.receiveBattleData(callback);
    return true;
  }

  Future<bool> stop() async {
    final success = await _client.disconnect();
    if (!success) {
      _logger.severe('critical error');
      return false;
    }

    _started = false;
    return true;
  }
}
