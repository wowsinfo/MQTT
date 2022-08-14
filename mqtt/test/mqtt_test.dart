import 'package:flutter_test/flutter_test.dart';
import 'package:mqtt/foundation/mqtt_client.dart';
import 'package:mqtt/model/game_data_manager.dart';

import 'test_data_loader.dart';

void main() {
  test('Test mqtt client', () async {
    final listener = WWSClient(
      clientID: 'henryquan.listener',
      userID: 'henryquan',
    );
    expect(await listener.initialise(), true);
    final manager = GameDataManager();
    int counter = 0;
    await listener.receiveBattleData((received) {
      expect(received, isNotEmpty);
      print('received: $received');
      final success = manager.update(received);
      if (success) counter += 1;

      if (counter == 16) {
        expect(manager.hasData, true);
        expect(manager.totalPlayers, 16);
      }
    });

    final client = WWSClient(
      clientID: 'henryquan.client',
      userID: 'henryquan',
    );
    final loader = TestDataLoader();
    final testData = await loader.loadTestJson();

    expect(await client.initialise(), true);
    expect(await client.pushServer('asia'), true);
    expect(await client.pushBattleInfo(testData), true);
    // delay 20s for response
    await Future.delayed(const Duration(seconds: 20));
    expect(await client.disconnect(), true);
    expect(await listener.disconnect(), true);
  });

  test('Load json', () async {
    final loader = TestDataLoader();
    final testData = await loader.loadTestJson();
    expect(testData, isNotNull);
    expect(testData, isNotEmpty);
  });
}
