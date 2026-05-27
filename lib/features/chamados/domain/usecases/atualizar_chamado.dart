import '../entities/chamado.dart';
import '../repositories/chamado_repository.dart';
import 'regra_negocio_exception.dart';

/// Atualiza um chamado existente, bloqueando edições em concluídos (RF14).
class AtualizarChamado {
  final ChamadoRepository repository;

  const AtualizarChamado(this.repository);

  Future<void> call(Chamado chamado) async {
    await _validar(chamado);
    await repository.atualizar(chamado);
  }

  Future<void> _validar(Chamado chamado) async {
    if (chamado.id == null) {
      throw const RegraNegocioException('Chamado sem identificador.');
    }

    final original = await repository.buscarPorId(chamado.id!);
    if (original == null) {
      throw const RegraNegocioException('Chamado não encontrado.');
    }
    if (!original.podeSerEditado) {
      throw const RegraNegocioException(
        'Chamados concluídos não podem ser editados.',
      );
    }
    if (chamado.descricao.trim().isEmpty) {
      throw const RegraNegocioException('A descrição não pode ser vazia.');
    }
    if (chamado.bairro.nome.trim().isEmpty) {
      throw const RegraNegocioException('O bairro é obrigatório.');
    }

    final tituloExiste = await repository.existeTitulo(
      chamado.titulo,
      ignorarId: chamado.id,
    );
    if (tituloExiste) {
      throw const RegraNegocioException('Já existe outro chamado com esse título.');
    }
  }
}
