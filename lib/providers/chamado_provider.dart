import 'package:flutter/material.dart';

import '../data/chamado_database.dart';
import '../models/chamado.dart';

class ChamadoProvider extends ChangeNotifier {
  ChamadoProvider(this._database);

  final ChamadoDatabase _database;
  final List<Chamado> _chamados = [];

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  List<Chamado> get chamadosOrdenados {
    final chamados = [..._chamados];
    chamados.sort((a, b) {
      final prioridadeA = _prioridadePeso(a.prioridade);
      final prioridadeB = _prioridadePeso(b.prioridade);
      if (prioridadeA != prioridadeB) {
        return prioridadeB.compareTo(prioridadeA);
      }
      return b.dataAbertura.compareTo(a.dataAbertura);
    });
    return chamados;
  }

  int get totalChamados => _chamados.length;
  int get abertos => _chamados.where((c) => c.status == StatusChamado.aberto).length;
  int get emAndamento => _chamados.where((c) => c.status == StatusChamado.emAndamento).length;
  int get concluidos => _chamados.where((c) => c.status == StatusChamado.concluido).length;
  int get criticos => _chamados.where((c) => c.prioridade == PrioridadeChamado.critica).length;
  bool get hasAlertaCritico => criticos > 5;

  Future<void> loadChamados() async {
    _setLoading(true);
    try {
      await _database.seedIfEmpty([
        Chamado(
          id: null,
          titulo: 'Buraco na Rua das Flores',
          descricao: 'Buraco profundo próximo ao cruzamento, oferecendo risco para veículos e motos.',
          categoria: CategoriaChamado.transito,
          prioridade: PrioridadeChamado.alta,
          bairro: 'Centro',
          responsavel: 'Equipe de Obras',
          dataAbertura: DateTime.now().subtract(const Duration(hours: 6)),
          status: StatusChamado.aberto,
        ),
        Chamado(
          id: null,
          titulo: 'Lâmpada queimada na praça',
          descricao: 'Trecho da praça principal sem iluminação durante a noite.',
          categoria: CategoriaChamado.iluminacao,
          prioridade: PrioridadeChamado.media,
          bairro: 'Jardim América',
          responsavel: 'Setor Elétrico',
          dataAbertura: DateTime.now().subtract(const Duration(hours: 12)),
          status: StatusChamado.emAndamento,
        ),
        Chamado(
          id: null,
          titulo: 'Árvore caída após chuva forte',
          descricao: 'Obstrução total da via com risco para pedestres.',
          categoria: CategoriaChamado.desastreNatural,
          prioridade: PrioridadeChamado.critica,
          bairro: 'Vila Nova',
          responsavel: 'Defesa Civil',
          dataAbertura: DateTime.now().subtract(const Duration(hours: 3)),
          status: StatusChamado.aberto,
        ),
      ]);
      _chamados
        ..clear()
        ..addAll(await _database.findAll());
      _error = null;
    } catch (e) {
      _error = 'Erro ao carregar chamados: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> salvarChamado(Chamado chamado) async {
    final tituloNormalizado = chamado.titulo.trim();
    if (tituloNormalizado.isEmpty) return 'Informe o título.';
    if (chamado.descricao.trim().isEmpty) return 'A descrição não pode ficar vazia.';
    if (chamado.bairro.trim().isEmpty) return 'Informe o bairro.';

    try {
      final existeTitulo = await _database.existsTitulo(tituloNormalizado, ignoreId: chamado.id);
      if (existeTitulo) return 'Já existe um chamado com esse título.';

      if (chamado.id == null) {
        final novoId = await _database.insert(chamado);
        _chamados.add(chamado.copyWith(id: novoId));
      } else {
        final atual = _chamados.firstWhere((item) => item.id == chamado.id);
        if (atual.isConcluido) return 'Chamados concluídos não podem ser editados.';

        await _database.update(chamado);
        final index = _chamados.indexWhere((item) => item.id == chamado.id);
        _chamados[index] = chamado;
      }

      _notify();
      return null;
    } catch (e) {
      return 'Não foi possível salvar o chamado: $e';
    }
  }

  Future<void> excluirChamado(int id) async {
    await _database.delete(id);
    _chamados.removeWhere((item) => item.id == id);
    _notify();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _notify() {
    _error = null;
    notifyListeners();
  }

  int _prioridadePeso(PrioridadeChamado prioridade) {
    switch (prioridade) {
      case PrioridadeChamado.baixa:
        return 1;
      case PrioridadeChamado.media:
        return 2;
      case PrioridadeChamado.alta:
        return 3;
      case PrioridadeChamado.critica:
        return 4;
    }
  }
}