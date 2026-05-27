import 'package:flutter/material.dart';

import '../../../../core/utils/categoria_icon_mapper.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/chamado.dart';

/// Item da lista de chamados exibido no dashboard.
class ChamadoTile extends StatelessWidget {
  final Chamado chamado;
  final VoidCallback onTap;

  const ChamadoTile({
    super.key,
    required this.chamado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final corPrioridade = _parseColor(chamado.prioridade.corHex);

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: corPrioridade.withOpacity(0.15),
          child: Icon(
            CategoriaIconMapper.fromName(chamado.categoria.icone),
            color: corPrioridade,
          ),
        ),
        title: Text(
          chamado.titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${chamado.categoria.nome} • ${chamado.bairro.nome}'),
            const SizedBox(height: 4),
            Row(
              children: [
                _Badge(texto: chamado.prioridade.nome, cor: corPrioridade),
                const SizedBox(width: 6),
                _Badge(
                  texto: chamado.status.nome,
                  cor: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              DateFormatter.timeElapsed(chamado.dataAbertura),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    return Color(int.parse('FF$cleaned', radix: 16));
  }
}

class _Badge extends StatelessWidget {
  final String texto;
  final Color cor;

  const _Badge({required this.texto, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: cor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
