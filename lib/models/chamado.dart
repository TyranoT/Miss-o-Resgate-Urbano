enum CategoriaChamado {
  transito,
  iluminacao,
  saneamento,
  seguranca,
  limpezaUrbana,
  desastreNatural,
}

extension CategoriaChamadoLabel on CategoriaChamado {
  // Retorna o rótulo amigável da categoria para exibição na interface.
  String get label {
    switch (this) {
      case CategoriaChamado.transito:
        return 'trânsito';
      case CategoriaChamado.iluminacao:
        return 'iluminação';
      case CategoriaChamado.saneamento:
        return 'saneamento';
      case CategoriaChamado.seguranca:
        return 'segurança';
      case CategoriaChamado.limpezaUrbana:
        return 'limpeza urbana';
      case CategoriaChamado.desastreNatural:
        return 'desastre natural';
    }
  }
}

enum PrioridadeChamado { baixa, media, alta, critica }

extension PrioridadeChamadoLabel on PrioridadeChamado {
  // Retorna o rótulo amigável da prioridade para exibição na interface.
  String get label {
    switch (this) {
      case PrioridadeChamado.baixa:
        return 'baixa';
      case PrioridadeChamado.media:
        return 'média';
      case PrioridadeChamado.alta:
        return 'alta';
      case PrioridadeChamado.critica:
        return 'crítica';
    }
  }
}

enum StatusChamado { aberto, emAndamento, concluido }

extension StatusChamadoLabel on StatusChamado {
  // Retorna o rótulo amigável do status para exibição na interface.
  String get label {
    switch (this) {
      case StatusChamado.aberto:
        return 'aberto';
      case StatusChamado.emAndamento:
        return 'em andamento';
      case StatusChamado.concluido:
        return 'concluído';
    }
  }
}

class Chamado {
  // Cria uma instância de chamado com todos os campos de domínio.
  Chamado({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.prioridade,
    required this.bairro,
    required this.responsavel,
    required this.dataAbertura,
    required this.status,
  });

  final int? id;
  final String titulo;
  final String descricao;
  final CategoriaChamado categoria;
  final PrioridadeChamado prioridade;
  final String bairro;
  final String responsavel;
  final DateTime dataAbertura;
  final StatusChamado status;

  Chamado copyWith({
    // Gera uma cópia do chamado preservando os valores não informados.
    int? id,
    String? titulo,
    String? descricao,
    CategoriaChamado? categoria,
    PrioridadeChamado? prioridade,
    String? bairro,
    String? responsavel,
    DateTime? dataAbertura,
    StatusChamado? status,
  }) {
    return Chamado(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      categoria: categoria ?? this.categoria,
      prioridade: prioridade ?? this.prioridade,
      bairro: bairro ?? this.bairro,
      responsavel: responsavel ?? this.responsavel,
      dataAbertura: dataAbertura ?? this.dataAbertura,
      status: status ?? this.status,
    );
  }

  bool get isConcluido => status == StatusChamado.concluido;

  // Converte o chamado em um mapa para salvar no SQLite.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'categoria': categoria.name,
      'prioridade': prioridade.name,
      'bairro': bairro,
      'responsavel': responsavel,
      'dataAbertura': dataAbertura.millisecondsSinceEpoch,
      'status': status.name,
    };
  }

  // Reconstrói um chamado a partir de um registro do banco.
  factory Chamado.fromMap(Map<String, Object?> map) {
    return Chamado(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String,
      categoria: CategoriaChamado.values.byName(map['categoria'] as String),
      prioridade: PrioridadeChamado.values.byName(map['prioridade'] as String),
      bairro: map['bairro'] as String,
      responsavel: map['responsavel'] as String,
      dataAbertura: DateTime.fromMillisecondsSinceEpoch(map['dataAbertura'] as int),
      status: StatusChamado.values.byName(map['status'] as String),
    );
  }
}