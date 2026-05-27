import '../../domain/entities/bairro.dart';
import '../../domain/entities/categoria.dart';
import '../../domain/entities/chamado.dart';
import '../../domain/entities/prioridade.dart';
import '../../domain/entities/responsavel.dart';
import '../../domain/entities/status.dart';

/// Converte rows de SQL (com joins) em entidades de domínio e vice-versa.
class ChamadoMapper {
  static Chamado fromMap(Map<String, dynamic> map) => Chamado(
        id: map['id'] as int,
        titulo: map['titulo'] as String,
        descricao: map['descricao'] as String,
        categoria: _categoriaFromMap(map),
        prioridade: _prioridadeFromMap(map),
        status: _statusFromMap(map),
        bairro: _bairroFromMap(map),
        responsavel: _responsavelFromMap(map),
        dataAbertura: DateTime.parse(map['data_abertura'] as String),
        dataAtualizacao: DateTime.parse(map['data_atualizacao'] as String),
        dataConclusao: map['data_conclusao'] != null
            ? DateTime.parse(map['data_conclusao'] as String)
            : null,
      );

  static Map<String, dynamic> toInsertMap(Chamado chamado) => {
        'titulo': chamado.titulo,
        'descricao': chamado.descricao,
        'categoria_id': chamado.categoria.id,
        'prioridade_id': chamado.prioridade.id,
        'status_id': chamado.status.id,
        'bairro_id': chamado.bairro.id,
        'responsavel_id': chamado.responsavel?.id,
        'data_abertura': chamado.dataAbertura.toIso8601String(),
        'data_atualizacao': chamado.dataAtualizacao.toIso8601String(),
        'data_conclusao': chamado.dataConclusao?.toIso8601String(),
      };

  static Categoria _categoriaFromMap(Map<String, dynamic> map) => Categoria(
        id: map['categoria_id'] as int,
        nome: map['categoria_nome'] as String,
        icone: map['categoria_icone'] as String,
        descricao: map['categoria_descricao'] as String?,
      );

  static Prioridade _prioridadeFromMap(Map<String, dynamic> map) => Prioridade(
        id: map['prioridade_id'] as int,
        nome: map['prioridade_nome'] as String,
        peso: map['prioridade_peso'] as int,
        corHex: map['prioridade_cor'] as String,
      );

  static Status _statusFromMap(Map<String, dynamic> map) => Status(
        id: map['status_id'] as int,
        nome: map['status_nome'] as String,
        permiteEdicao: (map['status_permite_edicao'] as int) == 1,
      );

  static Bairro _bairroFromMap(Map<String, dynamic> map) => Bairro(
        id: map['bairro_id'] as int,
        nome: map['bairro_nome'] as String,
        regiao: map['bairro_regiao'] as String?,
      );

  static Responsavel? _responsavelFromMap(Map<String, dynamic> map) {
    if (map['responsavel_id'] == null) return null;
    return Responsavel(
      id: map['responsavel_id'] as int,
      nome: map['responsavel_nome'] as String,
      setor: map['responsavel_setor'] as String?,
      contato: map['responsavel_contato'] as String?,
    );
  }
}
