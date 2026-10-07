import "package:flutter/material.dart";

import "l10n/strings.dart";
import "services/purchase_service.dart";
import "services/settings_service.dart";

class AppController extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  String languageCode = "en";
  bool pro = false;
  bool consented = false;
  bool ready = false;

  S get s => S(languageCode);

  Future<void> load() async {
    final settings = SettingsService.instance;
    await settings.init();
    themeMode = settings.themeMode;
    languageCode = settings.languageCode;
    pro = settings.pro;
    consented = settings.consented;
    PurchaseService.instance.onPro = (value) {
      pro = value;
      notifyListeners();
    };
    await PurchaseService.instance.init();
    ready = true;
    notifyListeners();
  }

  Future<void> acceptConsent() async {
    await SettingsService.instance.setConsent(true);
    consented = true;
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    languageCode = code;
    notifyListeners();
    await SettingsService.instance.setLanguage(code);
  }

  Future<void> setTheme(ThemeMode mode) async {
    themeMode = mode;
    notifyListeners();
    await SettingsService.instance.setTheme(mode);
  }

  Future<void> setPro(bool value) async {
    pro = value;
    notifyListeners();
    await SettingsService.instance.setPro(value);
  }
}

class AppScope extends InheritedNotifier<AppController> {
  const AppScope({required AppController controller, required super.child, super.key}) : super(notifier: controller);

  static AppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, "AppScope missing");
    return scope!.notifier!;
  }
}
