import '../../domain/entities/bairro.dart';
import '../../domain/entities/categoria.dart';
import '../../domain/entities/chamado.dart';
import '../../domain/entities/prioridade.dart';
import '../../domain/entities/responsavel.dart';
import '../../domain/entities/status.dart';
import '../../domain/repositories/chamado_repository.dart';
import '../datasources/chamado_datasource.dart';
import '../models/chamado_mapper.dart';

class ChamadoRepositoryImpl implements ChamadoRepository {
  final ChamadoDataSource dataSource;

  const ChamadoRepositoryImpl(this.dataSource);

  @override
  Future<List<Chamado>> listarTodos() async {
    final rows = await dataSource.queryChamadosComJoin();
    return rows.map(ChamadoMapper.fromMap).toList();
  }

  @override
  Future<Chamado?> buscarPorId(int id) async {
    final row = await dataSource.queryChamadoPorId(id);
    return row == null ? null : ChamadoMapper.fromMap(row);
  }

  @override
  Future<bool> existeTitulo(String titulo, {int? ignorarId}) {
    return dataSource.existeTitulo(titulo, ignorarId: ignorarId);
  }

  @override
  Future<int> criar(Chamado chamado) {
    final data = ChamadoMapper.toInsertMap(chamado);
    return dataSource.insertChamado(data);
  }

  @override
  Future<void> atualizar(Chamado chamado) async {
    if (chamado.id == null) {
      throw ArgumentError('Chamado sem id não pode ser atualizado.');
    }
    final data = ChamadoMapper.toInsertMap(chamado)
      ..['data_atualizacao'] = DateTime.now().toIso8601String();
    await dataSource.updateChamado(chamado.id!, data);
  }

  @override
  Future<void> excluir(int id) => dataSource.deleteChamado(id);

  @override
  Future<List<Categoria>> listarCategorias() async {
    final rows = await dataSource.queryAll('categoria');
    return rows.map(Categoria.fromMap).toList();
  }

  @override
  Future<List<Prioridade>> listarPrioridades() async {
    final rows = await dataSource.queryAll('prioridade');
    return rows.map(Prioridade.fromMap).toList();
  }

  @override
  Future<List<Status>> listarStatus() async {
    final rows = await dataSource.queryAll('status');
    return rows.map(Status.fromMap).toList();
  }

  @override
  Future<List<Bairro>> listarBairros() async {
    final rows = await dataSource.queryAll('bairro');
    return rows.map(Bairro.fromMap).toList();
  }

  @override
  Future<List<Responsavel>> listarResponsaveis() async {
    final rows = await dataSource.queryAll('responsavel');
    return rows.map(Responsavel.fromMap).toList();
  }
}
