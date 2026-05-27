import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/chamado.dart';

class ChamadoDatabase {
  static const _databaseName = 'sos_cidade.db';
  static const _databaseVersion = 1;
  static const tableChamados = 'chamados';

  Database? _database;

  Future<void> init() async {
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, _databaseName);

    _database = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableChamados (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL UNIQUE,
            descricao TEXT NOT NULL,
            categoria TEXT NOT NULL,
            prioridade TEXT NOT NULL,
            bairro TEXT NOT NULL,
            responsavel TEXT NOT NULL,
            dataAbertura INTEGER NOT NULL,
            status TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Database get _db {
    final database = _database;
    if (database == null) {
      throw StateError('Banco de dados nao inicializado.');
    }
    return database;
  }

  Future<List<Chamado>> findAll() async {
    final rows = await _db.query(tableChamados);
    return rows.map(Chamado.fromMap).toList();
  }

  Future<int> count() async {
    final result = Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM $tableChamados'));
    return result ?? 0;
  }

  Future<void> seedIfEmpty(List<Chamado> chamados) async {
    final total = await count();
    if (total > 0) return;

    final batch = _db.batch();
    for (final chamado in chamados) {
      batch.insert(tableChamados, chamado.toMap()..remove('id'));
    }
    await batch.commit(noResult: true);
  }

  Future<int> insert(Chamado chamado) async {
    return _db.insert(
      tableChamados,
      chamado.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<int> update(Chamado chamado) async {
    return _db.update(
      tableChamados,
      chamado.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [chamado.id],
    );
  }

  Future<int> delete(int id) async {
    return _db.delete(
      tableChamados,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> existsTitulo(String titulo, {int? ignoreId}) async {
    final result = await _db.query(
      tableChamados,
      columns: ['id'],
      where: ignoreId == null ? 'LOWER(titulo) = ?' : 'LOWER(titulo) = ? AND id != ?',
      whereArgs: ignoreId == null ? [titulo.toLowerCase()] : [titulo.toLowerCase(), ignoreId],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}