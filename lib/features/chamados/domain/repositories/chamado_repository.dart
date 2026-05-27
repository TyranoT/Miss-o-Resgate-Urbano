import '../entities/bairro.dart';
import '../entities/categoria.dart';
import '../entities/chamado.dart';
import '../entities/prioridade.dart';
import '../entities/responsavel.dart';
import '../entities/status.dart';

/// Contrato de acesso a dados de chamados e suas entidades relacionadas.
abstract class ChamadoRepository {
  Future<List<Chamado>> listarTodos();
  Future<Chamado?> buscarPorId(int id);
  Future<bool> existeTitulo(String titulo, {int? ignorarId});
  Future<int> criar(Chamado chamado);
  Future<void> atualizar(Chamado chamado);
  Future<void> excluir(int id);

  Future<List<Categoria>> listarCategorias();
  Future<List<Prioridade>> listarPrioridades();
  Future<List<Status>> listarStatus();
  Future<List<Bairro>> listarBairros();
  Future<List<Responsavel>> listarResponsaveis();
}
