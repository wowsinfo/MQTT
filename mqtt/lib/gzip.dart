import 'dart:convert';

import 'package:archive/archive.dart';

class GZipHelper {
  String? encode(String? json) {
    if (json == null) return null;
    final bytes = utf8.encode(json);
    final gzipBytes = GZipEncoder().encode(bytes);
    if (gzipBytes == null) return null;
    return base64.encode(gzipBytes);
  }

  String? decode(String? gzip) {
    if (gzip == null) return null;
    final bytes = base64.decode(gzip);
    final gzipBytes = GZipDecoder().decodeBytes(bytes);
    return utf8.decode(gzipBytes);
  }
}
