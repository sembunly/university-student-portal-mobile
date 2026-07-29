import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usp_mobile/screens/login_screen.dart';
import 'package:usp_mobile/services/auth_store.dart';

class MockAuthStore extends Mock implements AuthStore {}

void main() {
  testWidgets('login screen presents the primary authentication flow', (
    tester,
  ) async {
    final store = MockAuthStore();
    when(() => store.isBusy).thenReturn(false);
    when(() => store.errorMessage).thenReturn(null);
    when(() => store.addListener(any())).thenReturn(null);
    when(() => store.removeListener(any())).thenReturn(null);

    await tester.pumpWidget(CupertinoApp(home: LoginScreen(authStore: store)));

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
  });
}
