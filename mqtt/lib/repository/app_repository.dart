import 'package:mqtt/model/storage_provider.dart';

const String _replayFolderKey = 'replay_folder';

class AppRepository {
  static final AppRepository instance = AppRepository._init();
  AppRepository._init();

  // Storage
  late final StorageProvider _storage;
  void inject(StorageProvider storage) {
    _storage = storage;
  }

  // Replay folder path
  String? get replayFolder => _storage.getString(_replayFolderKey);
  set replayFolder(String? value) => _storage.set(_replayFolderKey, value);
}
