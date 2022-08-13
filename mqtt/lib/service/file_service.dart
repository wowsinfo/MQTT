import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:logging/logging.dart';

/// Read tempArenaInfo.json from the give path.
class FileService {
  final _logger = Logger('FileService');
  final String? path;
  FileService({required this.path});

  String? _json;

  String? get userID {
    if (_json == null) return null;
    final jsonMap = jsonDecode(_json!);
    final userID = jsonMap['playerName'];
    // lowercase + 8 random characters
    return userID?.toLowerCase() + Random().nextInt(1000000).toString();
  }

  FileService? validate() {
    if (path == null) {
      _logger.severe('path is invalid');
      return null;
    }
    _logger.info('$path is valid');
    return this;
  }

  /// Always call validate() before calling this method.
  Future<bool> load() async {
    try {
      final file = File(path!);
      final json = await file.readAsString();
      _logger.fine('Loaded json: $json');
      _json = json;
      return true;
    } on Exception catch (e) {
      // probably file not found
      _logger.severe('EXCEPTION: $e');
      return false;
    }
  }
}
