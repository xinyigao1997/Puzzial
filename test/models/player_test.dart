import 'package:test/test.dart';
import 'package:puzzial/models/player.dart';

void main() {
  group('Player tests', () {
    test('getPlayerInfo returns expected map', () {
      final player = Player(
          playerId: '123',
          emailAddress: 'test@example.com',
          userName: 'testuser',
          profilePhoto: 'https://example.com/profile.jpg');

      final expectedMap = {
        'playerId': '123',
        'emailAddress': 'test@example.com',
        'userName': 'testuser',
        'profilePhoto': 'https://example.com/profile.jpg'
      };

      expect(player.getPlayerInfo(), equals(expectedMap));
    });

   
  });
}