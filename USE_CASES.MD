// ==========================================================================
// SEÇÃO: #05 — USE CASES E REGRAS DE NEGÓCIO
// Arquivos localizados em: lib/features/chamados/domain/use_cases/
// ==========================================================================

import '../chamado_model.dart';

/// Contrato do Repositório (Interface)
/// Necessário para aplicar a Inversão de Dependência da Clean Architecture.
abstract class IChamadosRepository {
  Future<void> cadastrar(Chamado chamado);
  Future<List<Chamado>> listarTodos();
  Future<void> atualizar(Chamado chamado);
  Future<bool> verificarTituloExiste(String titulo);
}

// ==========================================================================
// 1. CASO DE USO: CADASTRAR CHAMADO
// ==========================================================================

class CadastrarChamadoUseCase {
  final IChamadosRepository _repository;

  CadastrarChamadoUseCase(this._repository);

  Future<void> execute(Chamado chamado) async {
    // Regra de Negócio: Não permitir título vazio ou apenas com espaços
    if (chamado.titulo.trim().isEmpty) {
      throw Exception('O título do chamado é obrigatório e não pode conter apenas espaços.');
    }

    // Regra de Negócio: Não permitir descrição vazia
    if (chamado.descricao.trim().isEmpty) {
      throw Exception('A descrição do chamado não pode estar vazia.');
    }

    // Regra de Negócio: Não permitir bairro vazio
    if (chamado.bairro.trim().isEmpty) {
      throw Exception('O bairro do chamado deve ser informado.');
    }

    // Regra de Negócio: Não permitir responsável vazio
    if (chamado.responsavel.trim().isEmpty) {
      throw Exception('O responsável pelo chamado deve ser informado.');
    }

    // Regra de Negócio: Validar Categorias permitidas pelo edital
    final categoriasValidas = ['trânsito', 'iluminação', 'saneamento', 'segurança', 'limpeza urbana', 'desastre natural'];
    if (!categoriasValidas.contains(chamado.categoria.toLowerCase())) {
      throw Exception('Categoria inválida. Selecione uma das opções permitidas.');
    }

    // Regra de Negócio: Validar Prioridades permitidas pelo edital
    final prioridadesValidas = ['baixa', 'média', 'alta', 'crítica'];
    if (!prioridadesValidas.contains(chamado.prioridade.toLowerCase())) {
      throw Exception('Prioridade inválida. Selecione uma das opções permitidas.');
    }

    // Regra de Negócio: Validar Status iniciais permitidos pelo edital
    final statusValidos = ['aberto', 'em andamento', 'concluído'];
    if (!statusValidos.contains(chamado.status.toLowerCase())) {
      throw Exception('Status inválido. Selecione uma das opções permitidas.');
    }

    // Regra de Negócio: Não permitir título repetido no sistema
    final tituloExiste = await _repository.verificarTituloExiste(chamado.titulo);
    if (tituloExiste) {
      throw Exception('Já existe um chamado cadastrado com este título.');
    }

    // Se passar por todos os filtros e validações, persiste no banco de dados
    await _repository.cadastrar(chamado);
  }
}

// ==========================================================================
// 2. CASO DE USO: ATUALIZAR CHAMADO
// ==========================================================================

class AtualizarChamadoUseCase {
  final IChamadosRepository _repository;
  final List<Chamado> _chamadosAtuais;

  /// O caso de uso recebe a lista atual em memória para validar o estado prévio do banco
  /// sem a necessidade de realizar múltiplas consultas assíncronas ao SQLite.
  AtualizarChamadoUseCase(this._repository, this._chamadosAtuais);

  Future<void> execute(Chamado chamadoEditado) async {
    // Localiza o registro original antes de qualquer modificação
    final chamadoOriginal = _chamadosAtuais.firstWhere(
      (c) => c.id == chamadoEditado.id,
      orElse: () => throw Exception('Chamado não encontrado na base de dados para atualização.'),
    );

    // Regra de Negócio: Chamados concluídos não podem ser editados de forma alguma
    if (chamadoOriginal.status.toLowerCase() == 'concluído') {
      throw Exception('Operação Negada: Este chamado já foi concluído e seu histórico está congelado.');
    }

    // Regra de Negócio: Impede que a edição limpe campos obrigatórios
    if (chamadoEditado.titulo.trim().isEmpty) {
      throw Exception('O título não pode ser apagado.');
    }
    if (chamadoEditado.descricao.trim().isEmpty) {
      throw Exception('A descrição não pode ser apagada.');
    }
    if (chamadoEditado.bairro.trim().isEmpty) {
      throw Exception('O campo bairro não pode ficar vazio.');
    }

    // Regra de Negócio: Se o título mudou, garante que o novo título não agrida a restrição de duplicidade
    if (chamadoOriginal.titulo != chamadoEditado.titulo) {
      final tituloExiste = await _repository.verificarTituloExiste(chamadoEditado.titulo);
      if (tituloExiste) {
        throw Exception('Não é possível renomear. Já existe outro chamado utilizando este título.');
      }
    }

    // Persiste as alterações validadas
    await _repository.atualizar(chamadoEditado);
  }
}

// ==========================================================================
// 3. CASO DE USO: LISTAR E ORDENAR CHAMADOS
// ==========================================================================

class ListarChamadosUseCase {
  final IChamadosRepository _repository;

  ListarChamadosUseCase(this._repository);

  Future<List<Chamado>> execute() async {
    final lista = await _repository.listarTodos();

    // Regra de Negócio: Chamados com prioridade alta ou crítica devem aparecer estritamente no topo.
    // O critério de desempate secundário mantém os registros ordenados pela data de abertura mais recente.
    lista.sort((a, b) {
      final comparacaoPrioridade = b.pesoPrioridade.compareTo(a.pesoPrioridade);
      if (comparacaoPrioridade != 0) {
        return comparacaoPrioridade;
      }
      return b.dataAbertura.compareTo(a.dataAbertura);
    });

    return lista;
  }
}