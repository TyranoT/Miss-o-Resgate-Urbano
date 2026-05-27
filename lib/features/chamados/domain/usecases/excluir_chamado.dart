import '../repositories/chamado_repository.dart';
import 'regra_negocio_exception.dart';

/// Remove um chamado do banco de dados.
class ExcluirChamado {
  final ChamadoRepository repository;

  const ExcluirChamado(this.repository);

  Future<void> call(int id) async {
    final chamado = await repository.buscarPorId(id);
    if (chamado == null) {
      throw const RegraNegocioException('Chamado não encontrado.');
    }
    await repository.excluir(id);
  }
}
