import 'package:flutter/material.dart';

/// Banner exibido quando há mais de 5 chamados críticos ativos (RF15).
class AlertaCriticosBanner extends StatelessWidget {
  final int total;

  const AlertaCriticosBanner({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Atenção: $total chamados críticos ativos. Ação imediata recomendada.',
              style: TextStyle(
                color: Colors.red.shade900,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
