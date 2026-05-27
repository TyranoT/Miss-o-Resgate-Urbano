import 'bairro.dart';
import 'categoria.dart';
import 'prioridade.dart';
import 'responsavel.dart';
import 'status.dart';

/// Entidade central do sistema: uma ocorrência urbana registrada.
class Chamado {
  final int? id;
  final String titulo;
  final String descricao;
  final Categoria categoria;
  final Prioridade prioridade;
  final Status status;
  final Bairro bairro;
  final Responsavel? responsavel;
  final DateTime dataAbertura;
  final DateTime dataAtualizacao;
  final DateTime? dataConclusao;

  const Chamado({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.prioridade,
    required this.status,
    required this.bairro,
    this.responsavel,
    required this.dataAbertura,
    required this.dataAtualizacao,
    this.dataConclusao,
  });

  /// Regra RF14: chamados concluídos não podem ser editados.
  bool get podeSerEditado => status.permiteEdicao;

  Duration get tempoDecorrido => DateTime.now().difference(dataAbertura);

  Chamado copyWith({
    int? id,
    String? titulo,
    String? descricao,
    Categoria? categoria,
    Prioridade? prioridade,
    Status? status,
    Bairro? bairro,
    Responsavel? responsavel,
    DateTime? dataAbertura,
    DateTime? dataAtualizacao,
    DateTime? dataConclusao,
  }) =>
      Chamado(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        descricao: descricao ?? this.descricao,
        categoria: categoria ?? this.categoria,
        prioridade: prioridade ?? this.prioridade,
        status: status ?? this.status,
        bairro: bairro ?? this.bairro,
        responsavel: responsavel ?? this.responsavel,
        dataAbertura: dataAbertura ?? this.dataAbertura,
        dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
        dataConclusao: dataConclusao ?? this.dataConclusao,
      );
}
