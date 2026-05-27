/// Nível de urgência de um chamado. O `peso` é usado para ordenação (RF10).
class Prioridade {
  final int id;
  final String nome;
  final int peso;
  final String corHex;

  const Prioridade({
    required this.id,
    required this.nome,
    required this.peso,
    required this.corHex,
  });

  bool get isAltaOuCritica => peso >= 3;
  bool get isCritica => nome == 'Crítica';

  factory Prioridade.fromMap(Map<String, dynamic> map) => Prioridade(
        id: map['id'] as int,
        nome: map['nome'] as String,
        peso: map['peso'] as int,
        corHex: map['cor_hex'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'peso': peso,
        'cor_hex': corHex,
      };
}
