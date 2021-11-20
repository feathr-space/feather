import 'package:flutter_test/flutter_test.dart';

import 'package:feathr/data/account.dart';

void main() {
  testWidgets(
    'Account is created properly from Json',
    (WidgetTester tester) async {
      Map<String, dynamic> data = {
        "id": "this is an id",
        "username": "username123",
        "display_name": "user display name",
        "locked": false,
        "bot": true,
        "avatarUrl": "avatar-url",
      };

      final account = Account.fromJson(data);
      expect(account.id, equals("this is an id"));
      expect(account.username, equals("username123"));
      expect(account.displayName, equals("user display name"));
      expect(account.isLocked, isFalse);
      expect(account.isBot, isTrue);
      expect(account.avatarUrl, equals("avatar-url"));
    },
  );
}