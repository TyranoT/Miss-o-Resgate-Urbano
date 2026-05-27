/// Bairro onde uma ocorrência foi registrada.
class Bairro {
  final int id;
  final String nome;
  final String? regiao;

  const Bairro({
    required this.id,
    required this.nome,
    this.regiao,
  });

  factory Bairro.fromMap(Map<String, dynamic> map) => Bairro(
        id: map['id'] as int,
        nome: map['nome'] as String,
        regiao: map['regiao'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'regiao': regiao,
      };
}
