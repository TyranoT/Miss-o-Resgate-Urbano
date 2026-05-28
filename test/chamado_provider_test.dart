import 'package:flutter_test/flutter_test.dart';

import 'package:miss_o_resgate_urbano/data/chamado_database.dart';
import 'package:miss_o_resgate_urbano/models/chamado.dart';
import 'package:miss_o_resgate_urbano/providers/chamado_provider.dart';

class FakeChamadoDatabase extends ChamadoDatabase {
  // Simula um banco em memória para testar o provider sem SQLite.
  final List<Chamado> _store = [];
  int _nextId = 1;

  @override
  Future<void> init() async {}

  @override
  Future<void> seedIfEmpty(List<Chamado> chamados) async {
    // Popula a loja apenas quando ainda não há dados.
    if (_store.isNotEmpty) return;
    for (final chamado in chamados) {
      _store.add(chamado.copyWith(id: _nextId++));
    }
  }

  @override
  Future<List<Chamado>> findAll() async {
    // Retorna os chamados gravados em memória.
    return List.unmodifiable(_store);
  }

  @override
  Future<int> insert(Chamado chamado) async {
    // Adiciona um chamado novo com id incremental.
    final novo = chamado.copyWith(id: _nextId++);
    _store.add(novo);
    return novo.id!;
  }

  @override
  Future<int> update(Chamado chamado) async {
    // Substitui o chamado existente na coleção em memória.
    final index = _store.indexWhere((item) => item.id == chamado.id);
    if (index == -1) {
      throw StateError('Chamado não encontrado.');
    }
    _store[index] = chamado;
    return 1;
  }

  @override
  Future<int> delete(int id) async {
    // Remove um chamado pelo id na estrutura fake.
    _store.removeWhere((item) => item.id == id);
    return 1;
  }

  @override
  Future<bool> existsTitulo(String titulo, {int? ignoreId}) async {
    // Verifica duplicidade de título dentro do repositório fake.
    return _store.any(
      (item) => item.titulo.toLowerCase() == titulo.toLowerCase() && item.id != ignoreId,
    );
  }
}

// Cria um chamado padrão para facilitar os testes de regra de negócio.
Chamado buildChamado({
  int? id,
  required String titulo,
  required PrioridadeChamado prioridade,
  StatusChamado status = StatusChamado.aberto,
}) {
  return Chamado(
    id: id,
    titulo: titulo,
    descricao: 'descricao',
    categoria: CategoriaChamado.transito,
    prioridade: prioridade,
    bairro: 'bairro',
    responsavel: 'responsavel',
    dataAbertura: DateTime(2026, 5, 27, 10, 0),
    status: status,
  );
}

void main() {
  // Testa carregamento, ordenação e contagens do provider.
  test('loadChamados carrega dados iniciais e ordena por prioridade', () async {
    final provider = ChamadoProvider(FakeChamadoDatabase());

    await provider.loadChamados();

    expect(provider.totalChamados, 3);
    expect(provider.chamadosOrdenados.first.prioridade, PrioridadeChamado.critica);
    expect(provider.abertos, 2);
    expect(provider.emAndamento, 1);
    expect(provider.criticos, 1);
  });

  // Testa bloqueio de duplicidade e campos obrigatórios.
  test('salvarChamado bloqueia título repetido e descrição vazia', () async {
    final provider = ChamadoProvider(FakeChamadoDatabase());
    await provider.loadChamados();

    final duplicado = buildChamado(
      titulo: 'Buraco na Rua das Flores',
      prioridade: PrioridadeChamado.media,
    );

    final erroDuplicado = await provider.salvarChamado(duplicado);
    expect(erroDuplicado, 'Já existe um chamado com esse título.');

    final vazio = buildChamado(
      titulo: 'Novo chamado',
      prioridade: PrioridadeChamado.media,
    ).copyWith(descricao: '');

    final erroVazio = await provider.salvarChamado(vazio);
    expect(erroVazio, 'A descrição não pode ficar vazia.');
  });

  // Testa o bloqueio de edição para chamados concluídos.
  test('chamado concluído não pode ser editado', () async {
    final provider = ChamadoProvider(FakeChamadoDatabase());
    await provider.loadChamados();

    final concluido = buildChamado(
      id: 99,
      titulo: 'Chamado finalizado',
      prioridade: PrioridadeChamado.baixa,
      status: StatusChamado.concluido,
    );

    await provider.salvarChamado(concluido);

    final editado = concluido.copyWith(descricao: 'nova descricao');
    final erroEdicao = await provider.salvarChamado(editado);

    expect(erroEdicao, 'Chamados concluídos não podem ser editados.');
  });

  // Testa fechamento de chamado e bloqueio de edição após concluir.
  test('fechar chamado conclui e bloqueia edicao posterior', () async {
    final provider = ChamadoProvider(FakeChamadoDatabase());
    await provider.loadChamados();

    final alvo = provider.chamadosOrdenados.firstWhere((item) => !item.isConcluido);

    final erroFechamento = await provider.fecharChamado(alvo.id!);
    expect(erroFechamento, isNull);

    final fechado = provider.chamadosOrdenados.firstWhere((item) => item.id == alvo.id);
    expect(fechado.isConcluido, isTrue);

    final tentativaEdicao = fechado.copyWith(descricao: 'alteracao apos fechamento');
    final erroEdicao = await provider.salvarChamado(tentativaEdicao);
    expect(erroEdicao, 'Chamados concluídos não podem ser editados.');
  });

  // Testa tentativa de fechar novamente um chamado já concluído.
  test('fechar chamado ja concluido retorna mensagem adequada', () async {
    final provider = ChamadoProvider(FakeChamadoDatabase());
    await provider.loadChamados();

    final chamado = buildChamado(
      titulo: 'Caso para fechamento duplicado',
      prioridade: PrioridadeChamado.media,
    );

    await provider.salvarChamado(chamado);
    final salvo = provider.chamadosOrdenados.firstWhere((item) => item.titulo == chamado.titulo);

    final primeiroFechamento = await provider.fecharChamado(salvo.id!);
    expect(primeiroFechamento, isNull);

    final segundoFechamento = await provider.fecharChamado(salvo.id!);
    expect(segundoFechamento, 'Esse chamado já está concluído.');
  });
}