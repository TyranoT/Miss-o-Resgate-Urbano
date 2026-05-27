import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'chamado_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chamados_municipais.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE chamados (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        descricao TEXT NOT NULL,
        bairro TEXT NOT NULL,
        responsavel TEXT NOT NULL,
        data TEXT NOT NULL,
        categoria TEXT NOT NULL CHECK(categoria IN ('trânsito', 'iluminação', 'saneamento', 'segurança', 'limpeza urbana', 'desastre natural')),
        prioridade TEXT NOT NULL CHECK(prioridade IN ('baixa', 'média', 'alta', 'crítica')),
        status TEXT NOT NULL CHECK(status IN ('aberto', 'em andamento', 'concluído'))
      )
    ''');
  }

  // Exemplo de Inserção (Create)
  Future<int> insertChamado(Chamado chamado) async {
    final db = await instance.database;
    return await db.insert('chamados', chamado.toMap());
  }

  // Exemplo de Leitura (Read All)
  Future<List<Chamado>> getTodosChamados() async {
    final db = await instance.database;
    final result = await db.query('chamados', orderBy: 'data DESC');

    return result.map((json) => Chamado.fromMap(json)).toList();
  }

  // Fechar o banco de dados
  Future close() async {
    final db = await _database;
    if (db != null) {
      await db.close();
    }
  }
}