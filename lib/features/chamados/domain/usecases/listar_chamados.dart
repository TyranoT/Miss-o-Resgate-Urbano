import '../entities/chamado.dart';
import '../repositories/chamado_repository.dart';

/// Lista chamados com prioridades alta e crítica no topo (RF10).
class ListarChamados {
  final ChamadoRepository repository;

  const ListarChamados(this.repository);

  Future<List<Chamado>> call() async {
    final chamados = await repository.listarTodos();
    return _ordenarPorPrioridade(chamados);
  }

  List<Chamado> _ordenarPorPrioridade(List<Chamado> chamados) {
    final ordenados = [...chamados];
    ordenados.sort((a, b) {
      final pesoCompare = b.prioridade.peso.compareTo(a.prioridade.peso);
      if (pesoCompare != 0) return pesoCompare;
      return b.dataAbertura.compareTo(a.dataAbertura);
    });
    return ordenados;
  }
}
