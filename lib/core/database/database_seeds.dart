import 'package:sqflite/sqflite.dart';

/// Popula as tabelas de domínio com os dados iniciais necessários ao app.
class DatabaseSeeds {
  static Future<void> insertInitialData(Database db) async {
    await _seedCategorias(db);
    await _seedPrioridades(db);
    await _seedStatus(db);
    await _seedBairros(db);
  }

  static Future<void> _seedCategorias(Database db) async {
    const categorias = [
      {'nome': 'Trânsito', 'icone': 'traffic'},
      {'nome': 'Iluminação', 'icone': 'lightbulb'},
      {'nome': 'Saneamento', 'icone': 'water_drop'},
      {'nome': 'Segurança', 'icone': 'shield'},
      {'nome': 'Limpeza Urbana', 'icone': 'delete'},
      {'nome': 'Desastre Natural', 'icone': 'warning'},
    ];

    for (final categoria in categorias) {
      await db.insert('categoria', categoria);
    }
  }

  static Future<void> _seedPrioridades(Database db) async {
    const prioridades = [
      {'nome': 'Baixa', 'peso': 1, 'cor_hex': '#4CAF50'},
      {'nome': 'Média', 'peso': 2, 'cor_hex': '#FFC107'},
      {'nome': 'Alta', 'peso': 3, 'cor_hex': '#FF9800'},
      {'nome': 'Crítica', 'peso': 4, 'cor_hex': '#F44336'},
    ];

    for (final prioridade in prioridades) {
      await db.insert('prioridade', prioridade);
    }
  }

  static Future<void> _seedStatus(Database db) async {
    const statusList = [
      {'nome': 'Aberto', 'permite_edicao': 1},
      {'nome': 'Em Andamento', 'permite_edicao': 1},
      {'nome': 'Concluído', 'permite_edicao': 0},
    ];

    for (final status in statusList) {
      await db.insert('status', status);
    }
  }

  static Future<void> _seedBairros(Database db) async {
    const bairros = [
      {'nome': 'Centro', 'regiao': 'Centro'},
      {'nome': 'Manaíra', 'regiao': 'Leste'},
      {'nome': 'Tambaú', 'regiao': 'Leste'},
      {'nome': 'Cabo Branco', 'regiao': 'Leste'},
      {'nome': 'Bancários', 'regiao': 'Sul'},
      {'nome': 'Mangabeira', 'regiao': 'Sul'},
      {'nome': 'Bessa', 'regiao': 'Norte'},
      {'nome': 'Cristo Redentor', 'regiao': 'Oeste'},
    ];

    for (final bairro in bairros) {
      await db.insert('bairro', bairro);
    }
  }
}
