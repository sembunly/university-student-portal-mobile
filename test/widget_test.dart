import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:usp_mobile/models/location_option.dart';
import 'package:usp_mobile/models/profile_update_request.dart';
import 'package:usp_mobile/models/student_account.dart';
import 'package:usp_mobile/models/student_profile.dart';
import 'package:usp_mobile/screens/dashboard_screen.dart';
import 'package:usp_mobile/screens/login_screen.dart';
import 'package:usp_mobile/services/auth_store.dart';

class MockAuthStore extends Mock implements AuthStore {}

void main() {
  test('profile request sends plain API values', () {
    const request = ProfileUpdateRequest(
      nameKm: ' សុខ ដារ៉ា ',
      nameEn: ' Sok Dara ',
      gender: 'ប្រុស',
      emergencyName: 'Sok Mom',
      emergencyPhone: '098765432',
      currentProvinceId: 1,
      currentDistrictId: 2,
      currentCommuneId: 3,
      currentVillageId: 4,
      permanentProvinceId: 1,
      permanentDistrictId: 2,
      permanentCommuneId: 3,
      permanentVillageId: 4,
    );

    final json = request.toJson();

    expect(json['name_km'], 'សុខ ដារ៉ា');
    expect(json['current_province_id'], 1);
    expect(json['email'], isNull);
  });

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

  testWidgets('profile quick access opens student information', (tester) async {
    final store = _dashboardStore();

    await tester.pumpWidget(
      CupertinoApp(home: DashboardScreen(authStore: store)),
    );

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('PERSONAL INFORMATION'), findsOneWidget);
    expect(find.text('Student Name'), findsOneWidget);
  });

  testWidgets('curriculum quick access opens curriculum page', (tester) async {
    final store = _dashboardStore();

    await tester.pumpWidget(
      CupertinoApp(home: DashboardScreen(authStore: store)),
    );

    await tester.tap(find.text('Curriculum'));
    await tester.pumpAndSettle();

    expect(find.text('Your curriculum'), findsOneWidget);
  });
}

MockAuthStore _dashboardStore() {
  final store = MockAuthStore();
  when(() => store.account).thenReturn(
    const StudentAccount(
      id: 1,
      phone: '012345678',
      studentId: '0001',
      profileCompleted: true,
    ),
  );
  when(
    () => store.profile,
  ).thenReturn(const StudentProfile(nameEn: 'Student Name'));
  when(() => store.provinces()).thenAnswer((_) async => <LocationOption>[]);
  return store;
}
