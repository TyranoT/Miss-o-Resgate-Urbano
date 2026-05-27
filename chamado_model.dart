class Chamado {
  final int? id;
  final String titulo;
  final String descricao;
  final String categoria;
  final String prioridade;
  final String bairro;
  final String responsavel;
  final String data; // Formato YYYY-MM-DD
  final String status;

  Chamado({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.prioridade,
    required this.bairro,
    required this.responsavel,
    required this.data,
    required this.status,
  });

  // Converte um Chamado em um Map para salvar no banco
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'categoria': categoria,
      'prioridade': prioridade,
      'bairro': bairro,
      'responsavel': responsavel,
      'data': data,
      'status': status,
    };
  }

  // Converte um Map do banco em um objeto Chamado
  factory Chamado.fromMap(Map<String, dynamic> map) {
    return Chamado(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      categoria: map['categoria'],
      prioridade: map['prioridade'],
      bairro: map['bairro'],
      responsavel: map['responsavel'],
      data: map['data'],
      status: map['status'],
    );
  }
}
