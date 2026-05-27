import 'package:flutter/material.dart';

/// Converte o nome do ícone (salvo no banco) em IconData do Material.
class CategoriaIconMapper {
  static const Map<String, IconData> _icones = {
    'traffic': Icons.traffic,
    'lightbulb': Icons.lightbulb,
    'water_drop': Icons.water_drop,
    'shield': Icons.shield,
    'delete': Icons.delete,
    'warning': Icons.warning,
  };

  static IconData fromName(String name) =>
      _icones[name] ?? Icons.report_problem;
}
