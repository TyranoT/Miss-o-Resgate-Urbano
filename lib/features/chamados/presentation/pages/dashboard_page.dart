import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/date_formatter.dart';
import '../providers/chamados_provider.dart';
import '../widgets/alerta_criticos_banner.dart';
import '../widgets/chamado_tile.dart';
import '../widgets/indicador_card.dart';
import 'cadastro_chamado_page.dart';
import 'detalhes_chamado_page.dart';

/// Tela inicial com indicadores e listagem de chamados.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChamadosProvider>().inicializar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS Cidade'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ChamadosProvider>().recarregar(),
          ),
        ],
      ),
      body: Consumer<ChamadosProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading && provider.chamados.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildBody(context, provider);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navegarParaCadastro(context),
        icon: const Icon(Icons.add),
        label: const Text('Novo chamado'),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ChamadosProvider provider) {
    return RefreshIndicator(
      onRefresh: provider.recarregar,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          _Header(total: provider.totalChamados),
          if (provider.alertaCriticos)
            AlertaCriticosBanner(total: provider.totalCriticos),
          _IndicadoresGrid(provider: provider),
          const SizedBox(height: 8),
          _ListaChamados(provider: provider),
        ],
      ),
    );
  }

  void _navegarParaCadastro(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CadastroChamadoPage()),
    );
  }
}

class _Header extends StatelessWidget {
  final int total;

  const _Header({required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hoje, ${DateFormatter.formatDateTime(DateTime.now())}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            '$total chamados registrados',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _IndicadoresGrid extends StatelessWidget {
  final ChamadosProvider provider;

  const _IndicadoresGrid({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
        children: [
          IndicadorCard(
            titulo: 'Abertos',
            valor: provider.totalAbertos,
            icone: Icons.inbox,
            cor: Colors.blue,
          ),
          IndicadorCard(
            titulo: 'Em andamento',
            valor: provider.totalEmAndamento,
            icone: Icons.autorenew,
            cor: Colors.orange,
          ),
          IndicadorCard(
            titulo: 'Concluídos',
            valor: provider.totalConcluidos,
            icone: Icons.check_circle,
            cor: Colors.green,
          ),
          IndicadorCard(
            titulo: 'Críticos',
            valor: provider.totalCriticos,
            icone: Icons.warning,
            cor: Colors.red,
          ),
        ],
      ),
    );
  }
}

class _ListaChamados extends StatelessWidget {
  final ChamadosProvider provider;

  const _ListaChamados({required this.provider});

  @override
  Widget build(BuildContext context) {
    if (provider.chamados.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: Text('Nenhum chamado registrado.')),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Chamados',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...provider.chamados.map(
            (chamado) => ChamadoTile(
              chamado: chamado,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetalhesChamadoPage(chamado: chamado),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
