import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/chamado.dart';
import '../../domain/entities/status.dart';
import '../providers/chamados_provider.dart';

/// Exibe os detalhes do chamado e permite mudança de status (RF07, RF08, RF14).
class DetalhesChamadoPage extends StatefulWidget {
  final Chamado chamado;

  const DetalhesChamadoPage({super.key, required this.chamado});

  @override
  State<DetalhesChamadoPage> createState() => _DetalhesChamadoPageState();
}

class _DetalhesChamadoPageState extends State<DetalhesChamadoPage> {
  late Status _statusSelecionado;

  @override
  void initState() {
    super.initState();
    _statusSelecionado = widget.chamado.status;
  }

  @override
  Widget build(BuildContext context) {
    final chamado = widget.chamado;
    final podeEditar = chamado.podeSerEditado;

    return Scaffold(
      appBar: AppBar(
        title: Text(chamado.titulo, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmarExclusao(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!podeEditar) _avisoConcluido(),
          _campo('Categoria', chamado.categoria.nome),
          _campo('Prioridade', chamado.prioridade.nome),
          _campo('Bairro', chamado.bairro.nome),
          _campo('Responsável', chamado.responsavel?.nome ?? 'Não atribuído'),
          _campo('Aberto em', DateFormatter.formatDateTime(chamado.dataAbertura)),
          _campo('Tempo decorrido', DateFormatter.timeElapsed(chamado.dataAbertura)),
          const Divider(height: 32),
          Text(
            'Descrição',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(chamado.descricao),
          const SizedBox(height: 24),
          if (podeEditar) _alterarStatus(),
        ],
      ),
    );
  }

  Widget _avisoConcluido() => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.lock, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text('Chamado concluído. Edições não permitidas.'),
            ),
          ],
        ),
      );

  Widget _campo(String label, String valor) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 130,
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(child: Text(valor)),
          ],
        ),
      );

  Widget _alterarStatus() {
    final provider = context.watch<ChamadosProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alterar status',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<Status>(
          value: _statusSelecionado,
          items: provider.statusList
              .map((s) => DropdownMenuItem(value: s, child: Text(s.nome)))
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => _statusSelecionado = value);
          },
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _salvar,
          icon: const Icon(Icons.save),
          label: const Text('Salvar alteração'),
        ),
      ],
    );
  }

  Future<void> _salvar() async {
    final agora = DateTime.now();
    final atualizado = widget.chamado.copyWith(
      status: _statusSelecionado,
      dataAtualizacao: agora,
      dataConclusao: _statusSelecionado.isConcluido ? agora : null,
    );

    final provider = context.read<ChamadosProvider>();
    final sucesso = await provider.atualizar(atualizado);

    if (!mounted) return;

    if (sucesso) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chamado atualizado!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.erro ?? 'Erro ao atualizar.')),
      );
    }
  }

  Future<void> _confirmarExclusao(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir chamado?'),
        content: const Text('Essa ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    final provider = context.read<ChamadosProvider>();
    final sucesso = await provider.excluir(widget.chamado.id!);

    if (!mounted) return;
    if (sucesso) Navigator.pop(context);
  }
}
