import 'package:flutter_test/flutter_test.dart';
import 'package:mqtt/gzip.dart';

void main() {
  test('Test gzip', () {
    const test1 = 'asia';

    final encodeBytes1 = GZipHelper.encodeBytes(test1);
    final decodedBytes1 = GZipHelper.decodeBytes(encodeBytes1);
    expect(decodedBytes1, test1);
  });
}
