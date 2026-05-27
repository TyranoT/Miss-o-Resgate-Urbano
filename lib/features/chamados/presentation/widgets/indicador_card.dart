import 'package:flutter/material.dart';

/// Card de indicador exibido no dashboard (abertos, em andamento, etc.).
class IndicadorCard extends StatelessWidget {
  final String titulo;
  final int valor;
  final IconData icone;
  final Color cor;

  const IndicadorCard({
    super.key,
    required this.titulo,
    required this.valor,
    required this.icone,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icone, color: cor, size: 28),
            const SizedBox(height: 8),
            Text(
              '$valor',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cor,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              titulo,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
