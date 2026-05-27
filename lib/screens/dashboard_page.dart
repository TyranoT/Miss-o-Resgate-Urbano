import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/chamado.dart';
import '../providers/chamado_provider.dart';
import 'chamado_form_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChamadoProvider>(
      builder: (context, provider, _) {
        return SafeArea(
          child: RefreshIndicator(
            onRefresh: provider.loadChamados,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _Header(
                    total: provider.totalChamados,
                    now: _now,
                    showAlert: provider.hasAlertaCritico,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(child: _StatusCard(title: 'Abertos', value: provider.abertos, color: const Color(0xFF2563EB))),
                        const SizedBox(width: 12),
                        Expanded(child: _StatusCard(title: 'Andamento', value: provider.emAndamento, color: const Color(0xFFF59E0B))),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Row(
                      children: [
                        Expanded(child: _StatusCard(title: 'Concluídos', value: provider.concluidos, color: const Color(0xFF16A34A))),
                        const SizedBox(width: 12),
                        Expanded(child: _StatusCard(title: 'Críticos', value: provider.criticos, color: const Color(0xFFDC2626))),
                      ],
                    ),
                  ),
                ),
                if (provider.hasAlertaCritico)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB91C1C),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.white),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Alerta: existe uma quantidade elevada de chamados críticos.',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                    child: Row(
                      children: const [
                        Text(
                          'Chamados recentes',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                if (provider.loading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (provider.chamadosOrdenados.isEmpty)
                  const SliverFillRemaining(
                    child: Center(
                      child: Text('Nenhum chamado cadastrado ainda.'),
                    ),
                  )
                else
                  SliverList.separated(
                    itemCount: provider.chamadosOrdenados.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final chamado = provider.chamadosOrdenados[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _ChamadoCard(
                          chamado: chamado,
                          onEdit: chamado.isConcluido
                              ? null
                              : () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ChamadoFormPage(chamado: chamado),
                                    ),
                                  );
                                },
                          onDelete: () => provider.excluirChamado(chamado.id!),
                        ),
                      );
                    },
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.total, required this.now, required this.showAlert});

  final int total;
  final DateTime now;
  final bool showAlert;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0F766E), Color(0xFF134E4A)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SOS Cidade', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
          const SizedBox(height: 8),
          Text(formatter.format(now), style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          Row(
            children: [
              _HeaderMetric(label: 'Total de chamados', value: total.toString()),
              const Spacer(),
              if (showAlert)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text('ALERTA CRÍTICO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  const _HeaderMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.title, required this.value, required this.color});

  final String title;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Text(value.toString(), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _ChamadoCard extends StatelessWidget {
  const _ChamadoCard({required this.chamado, required this.onEdit, required this.onDelete});

  final Chamado chamado;
  final VoidCallback? onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd/MM HH:mm').format(chamado.dataAbertura);
    final elapsed = DateTime.now().difference(chamado.dataAbertura);
    final elapsedText = '${elapsed.inHours}h ${elapsed.inMinutes.remainder(60)}m';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _priorityColor(chamado.prioridade).withOpacity(0.15),
          child: Icon(_categoryIcon(chamado.categoria), color: _priorityColor(chamado.prioridade)),
        ),
        title: Text(chamado.titulo, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Chip(text: chamado.categoria.name),
              _Chip(text: chamado.prioridade.name),
              _Chip(text: chamado.status.name),
              _Chip(text: chamado.bairro),
              _Chip(text: date),
              _Chip(text: elapsedText),
            ],
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'editar' && onEdit != null) onEdit!.call();
            if (value == 'excluir') onDelete();
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: 'editar', enabled: onEdit != null, child: const Text('Editar')),
            const PopupMenuItem(value: 'excluir', child: Text('Excluir')),
          ],
        ),
      ),
    );
  }

  Color _priorityColor(PrioridadeChamado prioridade) {
    switch (prioridade) {
      case PrioridadeChamado.baixa:
        return const Color(0xFF16A34A);
      case PrioridadeChamado.media:
        return const Color(0xFFF59E0B);
      case PrioridadeChamado.alta:
        return const Color(0xFFEA580C);
      case PrioridadeChamado.critica:
        return const Color(0xFFDC2626);
    }
  }

  IconData _categoryIcon(CategoriaChamado categoria) {
    switch (categoria) {
      case CategoriaChamado.transito:
        return Icons.traffic;
      case CategoriaChamado.iluminacao:
        return Icons.lightbulb;
      case CategoriaChamado.saneamento:
        return Icons.water_drop;
      case CategoriaChamado.seguranca:
        return Icons.security;
      case CategoriaChamado.limpezaUrbana:
        return Icons.delete_sweep;
      case CategoriaChamado.desastreNatural:
        return Icons.flood;
    }
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6F5),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}