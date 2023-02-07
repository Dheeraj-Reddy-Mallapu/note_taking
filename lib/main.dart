import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:note_taking/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: ((ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightDynamic ?? _defaultLightColorScheme,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkDynamic ?? _defaultDarkColorScheme,
        ),
        home: const HomeScreen(),
      );
    }));
  }
}

final _defaultLightColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);

final _defaultDarkColorScheme =
    ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);
