/// Agente público responsável por um chamado.
class Responsavel {
  final int id;
  final String nome;
  final String? setor;
  final String? contato;

  const Responsavel({
    required this.id,
    required this.nome,
    this.setor,
    this.contato,
  });

  factory Responsavel.fromMap(Map<String, dynamic> map) => Responsavel(
        id: map['id'] as int,
        nome: map['nome'] as String,
        setor: map['setor'] as String?,
        contato: map['contato'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'setor': setor,
        'contato': contato,
      };
}
