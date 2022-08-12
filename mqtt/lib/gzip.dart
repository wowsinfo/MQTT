import 'dart:convert';
import 'dart:io';

class GZipHelper {
  static List<int>? encodeBytes(String? json) {
    if (json == null) return null;
    final bytes = utf8.encode(json);
    return GZipCodec().encode(bytes);
  }

  static String? decodeBytes(List<int>? gzip) {
    if (gzip == null) return null;
    final decoded = GZipCodec().decode(gzip);
    return utf8.decode(decoded);
  }

  // static String? encode(String? json) {
  //   final gzipBytes = encodeBytes(json);
  //   if (gzipBytes == null) return null;
  //   return base64.encode(gzipBytes);
  // }

  // static String? decode(String? gzip) {
  //   if (gzip == null) return null;
  //   final gzipBytes = base64.decode(gzip);
  //   final bytes = decodeBytes(gzipBytes);
  //   if (bytes == null) return null;
  //   return utf8.decode(bytes);
  // }
}
