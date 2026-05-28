import 'package:flutter/material.dart';

import 'chamado_form_page.dart';
import 'dashboard_page.dart';

class HomeShell extends StatefulWidget {
  // Cria a casca principal com navegação inferior.
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Alterna entre dashboard e formulário pelo índice selecionado.
    final pages = [const DashboardPage(), const ChamadoFormPage()];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box_outlined),
            selectedIcon: Icon(Icons.add_box),
            label: 'Novo chamado',
          ),
        ],
      ),
    );
  }
}