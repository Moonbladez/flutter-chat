import 'package:flutter/material.dart';

ColorScheme _darkColorScheme() => ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.dark,
    );

final darkTheme = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: _darkColorScheme().inversePrimary,
    centerTitle: true,
  ),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
);

ColorScheme _lightColorScheme() => ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: Brightness.light,
    );

final lightTheme = ThemeData(
  colorScheme: _lightColorScheme(),
  appBarTheme: AppBarTheme(
    backgroundColor: _lightColorScheme().primary,
    foregroundColor: _lightColorScheme().onPrimary,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: _lightColorScheme().onPrimaryContainer,
      backgroundColor: _lightColorScheme().primaryContainer,
    ),
  ),
  useMaterial3: true,
);
