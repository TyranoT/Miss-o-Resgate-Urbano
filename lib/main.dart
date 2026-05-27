import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app.dart';
import 'data/chamado_database.dart';
import 'providers/chamado_provider.dart';

Future<void> main() async {
  // Inicializa o Flutter e o banco antes de subir a aplicação.
  WidgetsFlutterBinding.ensureInitialized();

  // Em desktop, usa a fábrica FFI para habilitar SQLite corretamente.
  if (!kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  final database = ChamadoDatabase();
  await database.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ChamadoProvider(database)..loadChamados(),
      child: const SosCidadeApp(),
    ),
  );
}