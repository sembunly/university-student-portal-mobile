import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final authStore = AuthStore();
  await authStore.restoreSession();

  runApp(UspApp(authStore: authStore));
}

class UspApp extends StatelessWidget {
  const UspApp({super.key, required this.authStore});

  final AuthStore authStore;

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'USP Student',
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.blue,
        scaffoldBackgroundColor: AppColors.background,
        barBackgroundColor: Color(0xF2F7F8FC),
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            color: AppColors.ink,
            fontFamily: '.SF Pro Text',
            fontSize: 16,
          ),
        ),
      ),
      home: AnimatedBuilder(
        animation: authStore,
        builder: (context, _) {
          if (authStore.isAuthenticated) {
            return DashboardScreen(authStore: authStore);
          }

          return LoginScreen(authStore: authStore);
        },
      ),
    );
  }
}

abstract final class AppColors {
  static const blue = Color(0xFF2457D6);
  static const blueDark = Color(0xFF153B9B);
  static const cyan = Color(0xFF5FD4E8);
  static const background = Color(0xFFF5F7FB);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF172033);
  static const secondary = Color(0xFF687086);
  static const border = Color(0xFFE3E7EF);
  static const error = Color(0xFFD92D4D);
  static const success = Color(0xFF168A68);
}
