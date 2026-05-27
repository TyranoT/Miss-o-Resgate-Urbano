import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/chamado_database.dart';
import 'providers/chamado_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = ChamadoDatabase();
  await database.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ChamadoProvider(database)..loadChamados(),
      child: const SosCidadeApp(),
    ),
  );
}