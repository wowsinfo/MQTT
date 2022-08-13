import 'package:mqtt/model/storage_provider.dart';

const String _replayFolderKey = 'replay_folder';
const String _gameServerKey = 'game_server';

class AppRepository {
  static final AppRepository instance = AppRepository._init();
  AppRepository._init();

  // Storage
  late final StorageProvider _storage;
  void inject(StorageProvider storage) {
    _storage = storage;
  }

  // Replay folder path as a stream
  String? get replayFolder => _storage.getString(_replayFolderKey);
  set replayFolder(String? value) => _storage.set(_replayFolderKey, value);

  // Game server
  String? get gameServer => _storage.getString(_gameServerKey);
  set gameServer(String? value) => _storage.set(_gameServerKey, value);
}
