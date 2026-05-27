import 'package:sqflite/sqflite.dart';

/// Cria todas as tabelas e índices do banco SOS Cidade.
class DatabaseSchema {
  static Future<void> createTables(Database db) async {
    await db.execute(_createCategoriaTable);
    await db.execute(_createPrioridadeTable);
    await db.execute(_createStatusTable);
    await db.execute(_createBairroTable);
    await db.execute(_createResponsavelTable);
    await db.execute(_createChamadoTable);
    await db.execute(_createHistoricoStatusTable);
    await _createIndexes(db);
  }

  static Future<void> _createIndexes(Database db) async {
    await db.execute('CREATE INDEX idx_chamado_prioridade ON chamado(prioridade_id)');
    await db.execute('CREATE INDEX idx_chamado_status ON chamado(status_id)');
    await db.execute('CREATE INDEX idx_chamado_bairro ON chamado(bairro_id)');
    await db.execute('CREATE INDEX idx_chamado_data ON chamado(data_abertura)');
  }

  static const _createCategoriaTable = '''
    CREATE TABLE categoria (
      id        INTEGER PRIMARY KEY AUTOINCREMENT,
      nome      TEXT NOT NULL UNIQUE,
      icone     TEXT NOT NULL,
      descricao TEXT
    )
  ''';

  static const _createPrioridadeTable = '''
    CREATE TABLE prioridade (
      id      INTEGER PRIMARY KEY AUTOINCREMENT,
      nome    TEXT NOT NULL UNIQUE,
      peso    INTEGER NOT NULL,
      cor_hex TEXT NOT NULL
    )
  ''';

  static const _createStatusTable = '''
    CREATE TABLE status (
      id              INTEGER PRIMARY KEY AUTOINCREMENT,
      nome            TEXT NOT NULL UNIQUE,
      permite_edicao  INTEGER NOT NULL DEFAULT 1
    )
  ''';

  static const _createBairroTable = '''
    CREATE TABLE bairro (
      id     INTEGER PRIMARY KEY AUTOINCREMENT,
      nome   TEXT NOT NULL UNIQUE,
      regiao TEXT
    )
  ''';

  static const _createResponsavelTable = '''
    CREATE TABLE responsavel (
      id      INTEGER PRIMARY KEY AUTOINCREMENT,
      nome    TEXT NOT NULL,
      setor   TEXT,
      contato TEXT
    )
  ''';

  static const _createChamadoTable = '''
    CREATE TABLE chamado (
      id                INTEGER PRIMARY KEY AUTOINCREMENT,
      titulo            TEXT NOT NULL UNIQUE,
      descricao         TEXT NOT NULL CHECK(length(descricao) > 0),
      categoria_id      INTEGER NOT NULL,
      prioridade_id     INTEGER NOT NULL,
      status_id         INTEGER NOT NULL,
      bairro_id         INTEGER NOT NULL,
      responsavel_id    INTEGER,
      data_abertura     TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
      data_atualizacao  TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
      data_conclusao    TEXT,
      FOREIGN KEY (categoria_id)   REFERENCES categoria(id),
      FOREIGN KEY (prioridade_id)  REFERENCES prioridade(id),
      FOREIGN KEY (status_id)      REFERENCES status(id),
      FOREIGN KEY (bairro_id)      REFERENCES bairro(id),
      FOREIGN KEY (responsavel_id) REFERENCES responsavel(id)
    )
  ''';

  static const _createHistoricoStatusTable = '''
    CREATE TABLE historico_status (
      id                  INTEGER PRIMARY KEY AUTOINCREMENT,
      chamado_id          INTEGER NOT NULL,
      status_anterior_id  INTEGER,
      status_novo_id      INTEGER NOT NULL,
      data_mudanca        TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
      observacao          TEXT,
      FOREIGN KEY (chamado_id)         REFERENCES chamado(id) ON DELETE CASCADE,
      FOREIGN KEY (status_anterior_id) REFERENCES status(id),
      FOREIGN KEY (status_novo_id)     REFERENCES status(id)
    )
  ''';
}
