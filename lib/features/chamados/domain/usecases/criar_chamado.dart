import '../entities/chamado.dart';
import '../repositories/chamado_repository.dart';
import 'regra_negocio_exception.dart';

/// Cria um novo chamado aplicando as regras RF11, RF12 e RF13.
class CriarChamado {
  final ChamadoRepository repository;

  const CriarChamado(this.repository);

  Future<int> call(Chamado chamado) async {
    await _validar(chamado);
    return repository.criar(chamado);
  }

  Future<void> _validar(Chamado chamado) async {
    if (chamado.titulo.trim().isEmpty) {
      throw const RegraNegocioException('O título é obrigatório.');
    }
    if (chamado.descricao.trim().isEmpty) {
      throw const RegraNegocioException('A descrição não pode ser vazia.');
    }
    if (chamado.bairro.nome.trim().isEmpty) {
      throw const RegraNegocioException('O bairro é obrigatório.');
    }

    final tituloExiste = await repository.existeTitulo(chamado.titulo);
    if (tituloExiste) {
      throw const RegraNegocioException('Já existe um chamado com esse título.');
    }
  }
}
