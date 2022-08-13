import 'dart:io';

class TestDataLoader {
  /// Loads the json file with the given [path].
  Future<String> _loadAsString(String path) async {
    final file = File(path);
    return await file.readAsString();
  }

  Future<String> loadTestJson() async {
    return await _loadAsString('test/test.json');
  }
}
