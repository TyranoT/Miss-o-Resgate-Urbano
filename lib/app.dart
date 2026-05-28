import 'package:flutter/material.dart';

import 'screens/home_shell.dart';

class SosCidadeApp extends StatelessWidget {
  const SosCidadeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configura tema, título e rota inicial do app.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SOS Cidade',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F8F7),
        useMaterial3: true,
      ),
      home: const HomeShell(),
    );
  }
}