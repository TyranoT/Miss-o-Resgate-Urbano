// Valida se o título foi preenchido.
String? validateTitulo(String value) {
  if (value.trim().isEmpty) {
    return 'Informe o título.';
  }
  return null;
}

// Valida se a descrição foi preenchida.

String? validateDescricao(String value) {
  if (value.trim().isEmpty) {
    return 'A descrição não pode ficar vazia.';
  }
  return null;
}

// Valida se o bairro foi preenchido.
String? validateBairro(String value) {
  if (value.trim().isEmpty) {
    return 'Informe o bairro.';
  }
  return null;
}

// Valida o chamado completo com as regras principais do cadastro.
String? validateChamadoCompleto({
  required String titulo,
  required String descricao,
  required String bairro,
  required bool tituloRepetido,
  required bool concluido,
}) {
  final erroTitulo = validateTitulo(titulo);
  if (erroTitulo != null) return erroTitulo;

  final erroDescricao = validateDescricao(descricao);
  if (erroDescricao != null) return erroDescricao;

  final erroBairro = validateBairro(bairro);
  if (erroBairro != null) return erroBairro;

  if (tituloRepetido) {
    return 'Já existe um chamado com esse título.';
  }

  if (concluido) {
    return 'Chamados concluídos não podem ser editados.';
  }

  return null;
}