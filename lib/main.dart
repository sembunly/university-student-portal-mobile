import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_store.dart';
import 'theme/app_theme.dart';

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
    return GetCupertinoApp(
      title: 'USP Student',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
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
