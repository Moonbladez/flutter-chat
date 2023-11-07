import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
);

_lightColorScheme() => ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.light,
    );

final lightTheme = ThemeData(
  colorScheme: _lightColorScheme(),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: _lightColorScheme().onPrimaryContainer,
      backgroundColor: _lightColorScheme().primaryContainer,
    ),
  ),
  useMaterial3: true,
);
