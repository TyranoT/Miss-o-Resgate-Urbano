Expanded(
  child: Consumer<ChamadosProvider>(
    builder: (_, provider, __) {
      final chamados = provider.chamadosOrdenados;

      if (chamados.isEmpty) {
        return const Center(
          child: Text(
            'Nenhum chamado encontrado',
          ),
        );
      }

      return ListView.builder(
        itemCount: chamados.length,
        itemBuilder: (_, index) {
          final chamado = chamados[index];

          return ChamadoTile(
            chamado: chamado,
            onTap: () {
              // navegar para detalhes
            },
          );
        },
      );
    },
  ),
)