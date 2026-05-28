import 'package:flutter/material.dart';

import '../../domain/entities/chamado.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/categoria_icon_mapper.dart';

class ChamadoTile extends StatelessWidget {
  final Chamado chamado;
  final VoidCallback? onTap;

  const ChamadoTile({
    super.key,
    required this.chamado,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final prioridadeColor = _getPrioridadeColor();

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ÍCONE
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: prioridadeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  CategoriaIconMapper.getIcon(chamado.categoria),
                  color: prioridadeColor,
                  size: 28,
                ),
              ),

              const SizedBox(width: 16),

              // CONTEÚDO
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TOPO
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chamado.titulo,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(width: 8),

                        _PrioridadeBadge(
                          label: chamado.prioridade.name.toUpperCase(),
                          color: prioridadeColor,
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // CATEGORIA
                    _InfoRow(
                      icon: Icons.category_rounded,
                      text: chamado.categoria.name,
                    ),

                    const SizedBox(height: 6),

                    // STATUS
                    _InfoRow(
                      icon: Icons.sync_alt_rounded,
                      text: chamado.status.name,
                    ),

                    const SizedBox(height: 6),

                    // BAIRRO
                    _InfoRow(
                      icon: Icons.location_on_rounded,
                      text: chamado.bairro.nome,
                    ),

                    const SizedBox(height: 14),

                    // RODAPÉ
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month_rounded,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          DateFormatter.formatDate(
                            chamado.dataAbertura,
                          ),
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const Spacer(),

                        Icon(
                          Icons.access_time_rounded,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),

                        const SizedBox(width: 6),

                        Text(
                          DateFormatter.tempoDecorrido(
                            chamado.dataAbertura,
                          ),
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPrioridadeColor() {
    switch (chamado.prioridade.name.toLowerCase()) {
      case 'critica':
        return Colors.red;

      case 'alta':
        return Colors.orange;

      case 'media':
        return Colors.amber;

      case 'baixa':
        return Colors.green;

      default:
        return Colors.blueGrey;
    }
  }
}

class _PrioridadeBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _PrioridadeBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey.shade700,
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade800,
            ),
          ),
        ),
      ],
    );
  }
}