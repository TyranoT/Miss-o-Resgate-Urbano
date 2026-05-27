/// Categoria de um chamado urbano (trânsito, iluminação, saneamento, etc).
class Categoria {
  final int id;
  final String nome;
  final String icone;
  final String? descricao;

  const Categoria({
    required this.id,
    required this.nome,
    required this.icone,
    this.descricao,
  });

  factory Categoria.fromMap(Map<String, dynamic> map) => Categoria(
        id: map['id'] as int,
        nome: map['nome'] as String,
        icone: map['icone'] as String,
        descricao: map['descricao'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'icone': icone,
        'descricao': descricao,
      };
}
