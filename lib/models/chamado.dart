enum CategoriaChamado {
  transito,
  iluminacao,
  saneamento,
  seguranca,
  limpezaUrbana,
  desastreNatural,
}

enum PrioridadeChamado { baixa, media, alta, critica }

enum StatusChamado { aberto, emAndamento, concluido }

class Chamado {
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