import 'package:cheddar/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme(
          primary: Colors.black87,
          onPrimary: Colors.white,
          secondary: Colors.white,
          onSecondary: Colors.black38,
          error: Colors.red,
          onError: Colors.black54,
          surface: const Color.fromARGB(255, 204, 192, 79),
          onSurface: Colors.black54,
          brightness: Brightness.light,
        )
        ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow,
          brightness: Brightness.dark
        )
      ),
      themeMode: ThemeMode.system,
      home: const WidgetTree(),
    );
  }
}
