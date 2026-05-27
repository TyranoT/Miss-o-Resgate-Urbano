import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/chamado.dart';

class ChamadoDatabase {
  // Define o nome, versão e tabela principal do banco local.
  static const _databaseName = 'sos_cidade.db';
  static const _databaseVersion = 1;
  static const tableChamados = 'chamados';

  Database? _database;

  // Abre ou cria o banco de dados local com a tabela de chamados.
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
    // Garante acesso seguro ao banco já inicializado.
    final database = _database;
    if (database == null) {
      throw StateError('Banco de dados nao inicializado.');
    }
    return database;
  }

  // Carrega todos os chamados salvos.
  Future<List<Chamado>> findAll() async {
    final rows = await _db.query(tableChamados);
    return rows.map(Chamado.fromMap).toList();
  }

  // Retorna a quantidade total de chamados cadastrados.
  Future<int> count() async {
    final result = Sqflite.firstIntValue(await _db.rawQuery('SELECT COUNT(*) FROM $tableChamados'));
    return result ?? 0;
  }

  // Insere dados iniciais somente se o banco estiver vazio.
  Future<void> seedIfEmpty(List<Chamado> chamados) async {
    final total = await count();
    if (total > 0) return;

    final batch = _db.batch();
    for (final chamado in chamados) {
      batch.insert(tableChamados, chamado.toMap()..remove('id'));
    }
    await batch.commit(noResult: true);
  }

  // Insere um novo chamado no banco.
  Future<int> insert(Chamado chamado) async {
    return _db.insert(
      tableChamados,
      chamado.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  // Atualiza um chamado já existente.
  Future<int> update(Chamado chamado) async {
    return _db.update(
      tableChamados,
      chamado.toMap()..remove('id'),
      where: 'id = ?',
      whereArgs: [chamado.id],
    );
  }

  // Remove um chamado pelo id.
  Future<int> delete(int id) async {
    return _db.delete(
      tableChamados,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Verifica se já existe um título repetido no banco.
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