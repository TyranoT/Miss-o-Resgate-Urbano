import 'package:sqflite/sqflite.dart';

import '../../../../core/database/database_helper.dart';

/// Acesso bruto ao SQLite para as tabelas de chamados.
class ChamadoDataSource {
  final DatabaseHelper _helper;

  ChamadoDataSource({DatabaseHelper? helper})
      : _helper = helper ?? DatabaseHelper.instance;

  Future<Database> get _db async => _helper.database;

  Future<List<Map<String, dynamic>>> queryChamadosComJoin() async {
    final db = await _db;
    return db.rawQuery('''
      SELECT 
        c.id,
        c.titulo,
        c.descricao,
        c.data_abertura,
        c.data_atualizacao,
        c.data_conclusao,
        cat.id AS categoria_id, cat.nome AS categoria_nome, 
        cat.icone AS categoria_icone, cat.descricao AS categoria_descricao,
        p.id AS prioridade_id, p.nome AS prioridade_nome, 
        p.peso AS prioridade_peso, p.cor_hex AS prioridade_cor,
        s.id AS status_id, s.nome AS status_nome, 
        s.permite_edicao AS status_permite_edicao,
        b.id AS bairro_id, b.nome AS bairro_nome, b.regiao AS bairro_regiao,
        r.id AS responsavel_id, r.nome AS responsavel_nome,
        r.setor AS responsavel_setor, r.contato AS responsavel_contato
      FROM chamado c
      INNER JOIN categoria cat ON c.categoria_id = cat.id
      INNER JOIN prioridade p ON c.prioridade_id = p.id
      INNER JOIN status s ON c.status_id = s.id
      INNER JOIN bairro b ON c.bairro_id = b.id
      LEFT JOIN responsavel r ON c.responsavel_id = r.id
      ORDER BY c.data_abertura DESC
    ''');
  }

  Future<Map<String, dynamic>?> queryChamadoPorId(int id) async {
    final db = await _db;
    final results = await db.rawQuery('''
      SELECT 
        c.id, c.titulo, c.descricao,
        c.data_abertura, c.data_atualizacao, c.data_conclusao,
        cat.id AS categoria_id, cat.nome AS categoria_nome, 
        cat.icone AS categoria_icone, cat.descricao AS categoria_descricao,
        p.id AS prioridade_id, p.nome AS prioridade_nome, 
        p.peso AS prioridade_peso, p.cor_hex AS prioridade_cor,
        s.id AS status_id, s.nome AS status_nome, 
        s.permite_edicao AS status_permite_edicao,
        b.id AS bairro_id, b.nome AS bairro_nome, b.regiao AS bairro_regiao,
        r.id AS responsavel_id, r.nome AS responsavel_nome,
        r.setor AS responsavel_setor, r.contato AS responsavel_contato
      FROM chamado c
      INNER JOIN categoria cat ON c.categoria_id = cat.id
      INNER JOIN prioridade p ON c.prioridade_id = p.id
      INNER JOIN status s ON c.status_id = s.id
      INNER JOIN bairro b ON c.bairro_id = b.id
      LEFT JOIN responsavel r ON c.responsavel_id = r.id
      WHERE c.id = ?
    ''', [id]);

    return results.isEmpty ? null : results.first;
  }

  Future<bool> existeTitulo(String titulo, {int? ignorarId}) async {
    final db = await _db;
    final query = ignorarId == null
        ? 'SELECT COUNT(*) AS total FROM chamado WHERE titulo = ?'
        : 'SELECT COUNT(*) AS total FROM chamado WHERE titulo = ? AND id != ?';
    final args = ignorarId == null ? [titulo] : [titulo, ignorarId];
    final result = await db.rawQuery(query, args);
    return (result.first['total'] as int) > 0;
  }

  Future<int> insertChamado(Map<String, dynamic> data) async {
    final db = await _db;
    return db.insert('chamado', data);
  }

  Future<void> updateChamado(int id, Map<String, dynamic> data) async {
    final db = await _db;
    await db.update('chamado', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteChamado(int id) async {
    final db = await _db;
    await db.delete('chamado', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAll(String tabela) async {
    final db = await _db;
    return db.query(tabela, orderBy: 'nome ASC');
  }
}
