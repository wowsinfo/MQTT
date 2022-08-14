import 'package:mqtt/foundation/app.dart';
import 'package:mqtt/model/storage_provider.dart';
import 'package:uuid/uuid.dart';

const String _replayFolderKey = 'replay_folder';
const String _gameServerKey = 'game_server';
const String _userUUIDKey = 'user_uuid';

class AppRepository {
  static final AppRepository instance = AppRepository._init();
  AppRepository._init();

  // Storage
  late final StorageProvider _storage;
  void inject(StorageProvider storage) {
    _storage = storage;
    if (App.isWindows) _generateUserUUID();
  }

  // Replay folder path as a stream
  String? get replayFolder => _storage.getString(_replayFolderKey);
  set replayFolder(String? value) => _storage.set(_replayFolderKey, value);

  // Game server
  String? get gameServer => _storage.getString(_gameServerKey);
  set gameServer(String? value) => _storage.set(_gameServerKey, value);

  // User UUID
  String? get userUUID {
    final savedID = _storage.getString(_userUUIDKey);
    return savedID;
  }

  set userUUID(String? value) {
    if (App.isMobile) _storage.set(_userUUIDKey, value);
    throw UnsupportedError('Don\'t set userUUID on desktop');
  }

  bool get hasUserUUID => _storage.hasKey(_userUUIDKey);
  void _generateUserUUID() {
    if (userUUID == null) {
      // save this UUID to be used in the future
      const uuid = Uuid();
      final id = uuid.v4();
      _storage.set(_userUUIDKey, id);
    }
  }
}
