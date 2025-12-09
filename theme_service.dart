import 'package:flutter/material.dart';

class ThemeService {
  ThemeService._private();
  static final ThemeService instance = ThemeService._private();

  final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.system);

  ThemeMode get current => mode.value;

  void toggle() {
    if (mode.value == ThemeMode.light) {
      mode.value = ThemeMode.dark;
    } else {
      mode.value = ThemeMode.light;
    }
  }

  void setSystem() => mode.value = ThemeMode.system;
  void setLight() => mode.value = ThemeMode.light;
  void setDark() => mode.value = ThemeMode.dark;
}
