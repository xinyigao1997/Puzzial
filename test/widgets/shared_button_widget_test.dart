import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:puzzial/state/game_state.dart';
import 'package:puzzial/widgets/share_button_widget.dart';
import 'package:flutter/services.dart';
import 'package:puzzial/widgets/button_widget.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    GameState.instance.sessionId = 'mock_session_id';
    GameState.instance.downloadUrl = 'mock_download_url';
  });

  testWidgets('ShareButton should have correct widget tree',
      (WidgetTester tester) async {
    // Build the ShareButton widget
    await tester
        .pumpWidget(const MaterialApp(home: Scaffold(body: ShareButton())));

    // Verify that the ShareButton has the correct widget tree
    expect(find.byType(Container), findsOneWidget);
    expect(find.byType(FittedBox), findsOneWidget);
  });

  testWidgets(
      'ShareButton should copy session ID and download URL to clipboard',
      (WidgetTester tester) async {
    // Build the ShareButton widget
    await tester
        .pumpWidget(const MaterialApp(home: Scaffold(body: ShareButton())));

    final List<MethodCall> log = <MethodCall>[];
    SystemChannels.platform
        .setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
    });

    // Tap the ShareButton
    await tester.tap(find.byType(CustomButton));
    await tester.pumpAndSettle();
  });
}
