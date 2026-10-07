import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";

import "app_controller.dart";
import "screens/consent_screen.dart";
import "screens/home_screen.dart";
import "theme/app_theme.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller = AppController();
  await controller.load();
  runApp(VideoLogoCleanerApp(controller: controller));
}

class VideoLogoCleanerApp extends StatelessWidget {
  const VideoLogoCleanerApp({required this.controller, super.key});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      controller: controller,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final s = controller.s;
          return MaterialApp(
            title: s.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: controller.themeMode,
            locale: Locale(controller.languageCode),
            supportedLocales: const [Locale("en"), Locale("si")],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: !controller.ready
                ? const Scaffold(body: Center(child: CircularProgressIndicator()))
                : controller.consented
                    ? const HomeScreen()
                    : const ConsentScreen(),
          );
        },
      ),
    );
  }
}
