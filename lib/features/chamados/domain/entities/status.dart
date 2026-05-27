/// Estado de andamento de um chamado (aberto, em andamento, concluído).
class Status {
  final int id;
  final String nome;
  final bool permiteEdicao;

  const Status({
    required this.id,
    required this.nome,
    required this.permiteEdicao,
  });

  bool get isConcluido => nome == 'Concluído';
  bool get isAberto => nome == 'Aberto';
  bool get isEmAndamento => nome == 'Em Andamento';

  factory Status.fromMap(Map<String, dynamic> map) => Status(
        id: map['id'] as int,
        nome: map['nome'] as String,
        permiteEdicao: (map['permite_edicao'] as int) == 1,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'permite_edicao': permiteEdicao ? 1 : 0,
      };
}
