import 'package:flutter/foundation.dart';

import '../../domain/entities/bairro.dart';
import '../../domain/entities/categoria.dart';
import '../../domain/entities/chamado.dart';
import '../../domain/entities/prioridade.dart';
import '../../domain/entities/responsavel.dart';
import '../../domain/entities/status.dart';
import '../../domain/repositories/chamado_repository.dart';
import '../../domain/usecases/atualizar_chamado.dart';
import '../../domain/usecases/criar_chamado.dart';
import '../../domain/usecases/excluir_chamado.dart';
import '../../domain/usecases/listar_chamados.dart';

/// Gerencia o estado global de chamados e expõe contadores para o dashboard.
class ChamadosProvider extends ChangeNotifier {
  static const int _limiteCriticos = 5;

  final ListarChamados _listarChamados;
  final CriarChamado _criarChamado;
  final AtualizarChamado _atualizarChamado;
  final ExcluirChamado _excluirChamado;
  final ChamadoRepository _repository;

  List<Chamado> _chamados = [];
  List<Categoria> _categorias = [];
  List<Prioridade> _prioridades = [];
  List<Status> _statusList = [];
  List<Bairro> _bairros = [];
  List<Responsavel> _responsaveis = [];
  bool _isLoading = false;
  String? _erro;

  ChamadosProvider({
    required ListarChamados listarChamados,
    required CriarChamado criarChamado,
    required AtualizarChamado atualizarChamado,
    required ExcluirChamado excluirChamado,
    required ChamadoRepository repository,
  })  : _listarChamados = listarChamados,
        _criarChamado = criarChamado,
        _atualizarChamado = atualizarChamado,
        _excluirChamado = excluirChamado,
        _repository = repository;

  List<Chamado> get chamados => _chamados;
  List<Categoria> get categorias => _categorias;
  List<Prioridade> get prioridades => _prioridades;
  List<Status> get statusList => _statusList;
  List<Bairro> get bairros => _bairros;
  List<Responsavel> get responsaveis => _responsaveis;
  bool get isLoading => _isLoading;
  String? get erro => _erro;

  int get totalChamados => _chamados.length;
  int get totalAbertos => _contarPorStatus('Aberto');
  int get totalEmAndamento => _contarPorStatus('Em Andamento');
  int get totalConcluidos => _contarPorStatus('Concluído');
  int get totalCriticos => _chamados.where((c) => c.prioridade.isCritica).length;

  /// RF15: alerta quando há mais de 5 chamados críticos.
  bool get alertaCriticos => totalCriticos > _limiteCriticos;

  Future<void> inicializar() async {
    await _carregarAuxiliares();
    await recarregar();
  }

  Future<void> recarregar() async {
    _setLoading(true);
    try {
      _chamados = await _listarChamados();
      _erro = null;
    } catch (e) {
      _erro = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> criar(Chamado chamado) async {
    try {
      await _criarChamado(chamado);
      await recarregar();
      return true;
    } catch (e) {
      _erro = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> atualizar(Chamado chamado) async {
    try {
      await _atualizarChamado(chamado);
      await recarregar();
      return true;
    } catch (e) {
      _erro = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> excluir(int id) async {
    try {
      await _excluirChamado(id);
      await recarregar();
      return true;
    } catch (e) {
      _erro = e.toString();
      notifyListeners();
      return false;
    }
  }

  void limparErro() {
    _erro = null;
    notifyListeners();
  }

  Future<void> _carregarAuxiliares() async {
    _categorias = await _repository.listarCategorias();
    _prioridades = await _repository.listarPrioridades();
    _statusList = await _repository.listarStatus();
    _bairros = await _repository.listarBairros();
    _responsaveis = await _repository.listarResponsaveis();
  }

  int _contarPorStatus(String nomeStatus) {
    return _chamados.where((c) => c.status.nome == nomeStatus).length;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
