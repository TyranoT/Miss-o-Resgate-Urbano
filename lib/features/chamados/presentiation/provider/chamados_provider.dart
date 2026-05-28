import 'package:flutter/material.dart';
import 'package:missao_resgate_urbano/features/chamados/domain/entities/chamado.dart';

List<Chamado> get chamadosOrdenados {
  final lista = [..._chamados];

  lista.sort((a, b) {
    final prioridadeA = _pesoPrioridade(a.prioridade.name);
    final prioridadeB = _pesoPrioridade(b.prioridade.name);

    if (prioridadeA != prioridadeB) {
      return prioridadeA.compareTo(prioridadeB);
    }

    return b.dataAbertura.compareTo(a.dataAbertura);
  });

  return lista;
}

int _pesoPrioridade(String prioridade) {
  switch (prioridade.toLowerCase()) {
    case 'critica':
      return 0;

    case 'alta':
      return 1;

    case 'media':
      return 2;

    case 'baixa':
      return 3;

    default:
      return 99;
  }
}