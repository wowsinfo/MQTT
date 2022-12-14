import 'package:mqtt/foundation/storage_provider.dart';

class StorageService {
  final StorageProvider _provider;
  StorageService(this._provider);

  String? getString(String key) => _provider.getString(key);
  void setString(String key, String? value) => _provider.set(key, value);
  bool hasKey(String key) => _provider.hasKey(key);
}
