import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chamado.dart';
import '../providers/chamado_provider.dart';

class ChamadoFormPage extends StatefulWidget {
  const ChamadoFormPage({super.key, this.chamado});

  final Chamado? chamado;

  @override
  State<ChamadoFormPage> createState() => _ChamadoFormPageState();
}

class _ChamadoFormPageState extends State<ChamadoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloController;
  late final TextEditingController _descricaoController;
  late final TextEditingController _bairroController;
  late final TextEditingController _responsavelController;

  late CategoriaChamado _categoria;
  late PrioridadeChamado _prioridade;
  late StatusChamado _status;
  late DateTime _dataAbertura;

  bool get _isEditing => widget.chamado != null;

  @override
  void initState() {
    super.initState();
    final chamado = widget.chamado;
    _tituloController = TextEditingController(text: chamado?.titulo ?? '');
    _descricaoController = TextEditingController(text: chamado?.descricao ?? '');
    _bairroController = TextEditingController(text: chamado?.bairro ?? '');
    _responsavelController = TextEditingController(text: chamado?.responsavel ?? '');
    _categoria = chamado?.categoria ?? CategoriaChamado.transito;
    _prioridade = chamado?.prioridade ?? PrioridadeChamado.media;
    _status = chamado?.status ?? StatusChamado.aberto;
    _dataAbertura = chamado?.dataAbertura ?? DateTime.now();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _bairroController.dispose();
    _responsavelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChamadoProvider>();
    final chamadoAtual = widget.chamado;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar chamado' : 'Novo chamado'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (chamadoAtual?.isConcluido ?? false)
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: _InfoBanner(
                  text: 'Chamados concluídos não podem ser editados.',
                  icon: Icons.lock,
                ),
              ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _TextField(controller: _tituloController, label: 'Título', enabled: !(chamadoAtual?.isConcluido ?? false)),
                  _TextField(controller: _descricaoController, label: 'Descrição', maxLines: 4, enabled: !(chamadoAtual?.isConcluido ?? false)),
                  _DropdownField<CategoriaChamado>(
                    label: 'Categoria',
                    value: _categoria,
                    items: CategoriaChamado.values,
                    onChanged: (value) => setState(() => _categoria = value!),
                    itemLabel: (value) => value.name,
                    enabled: !(chamadoAtual?.isConcluido ?? false),
                  ),
                  _DropdownField<PrioridadeChamado>(
                    label: 'Prioridade',
                    value: _prioridade,
                    items: PrioridadeChamado.values,
                    onChanged: (value) => setState(() => _prioridade = value!),
                    itemLabel: (value) => value.name,
                    enabled: !(chamadoAtual?.isConcluido ?? false),
                  ),
                  _TextField(controller: _bairroController, label: 'Bairro', enabled: !(chamadoAtual?.isConcluido ?? false)),
                  _TextField(controller: _responsavelController, label: 'Responsável', enabled: !(chamadoAtual?.isConcluido ?? false)),
                  _DropdownField<StatusChamado>(
                    label: 'Status',
                    value: _status,
                    items: StatusChamado.values,
                    onChanged: (value) => setState(() => _status = value!),
                    itemLabel: (value) => value.name,
                    enabled: !(chamadoAtual?.isConcluido ?? false),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Data de abertura'),
                    subtitle: Text(_dataAbertura.toIso8601String()),
                    trailing: const Icon(Icons.event),
                    onTap: chamadoAtual?.isConcluido ?? false
                        ? null
                        : () async {
                            final selected = await showDatePicker(
                              context: context,
                              initialDate: _dataAbertura,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2100),
                            );
                            if (selected != null) {
                              setState(() => _dataAbertura = DateTime(
                                selected.year,
                                selected.month,
                                selected.day,
                                _dataAbertura.hour,
                                _dataAbertura.minute,
                              ));
                            }
                          },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: provider.loading || (chamadoAtual?.isConcluido ?? false)
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;

                              final chamado = Chamado(
                                id: chamadoAtual?.id,
                                titulo: _tituloController.text.trim(),
                                descricao: _descricaoController.text.trim(),
                                categoria: _categoria,
                                prioridade: _prioridade,
                                bairro: _bairroController.text.trim(),
                                responsavel: _responsavelController.text.trim(),
                                dataAbertura: _dataAbertura,
                                status: _status,
                              );

                              final erro = await provider.salvarChamado(chamado);
                              if (!context.mounted) return;

                              if (erro != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(erro)),
                                );
                                return;
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(_isEditing ? 'Chamado atualizado.' : 'Chamado criado.')),
                              );
                              if (!_isEditing) {
                                _formKey.currentState?.reset();
                                setState(() {
                                  _tituloController.clear();
                                  _descricaoController.clear();
                                  _bairroController.clear();
                                  _responsavelController.clear();
                                  _categoria = CategoriaChamado.transito;
                                  _prioridade = PrioridadeChamado.media;
                                  _status = StatusChamado.aberto;
                                  _dataAbertura = DateTime.now();
                                });
                              }
                            },
                      icon: Icon(_isEditing ? Icons.save : Icons.add_task),
                      label: Text(_isEditing ? 'Salvar alterações' : 'Cadastrar chamado'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({required this.controller, required this.label, this.maxLines = 1, this.enabled = true});

  final TextEditingController controller;
  final String label;
  final int maxLines;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: (value) {
          if (label == 'Título' && (value == null || value.trim().isEmpty)) {
            return 'Informe o título.';
          }
          if (label == 'Descrição' && (value == null || value.trim().isEmpty)) {
            return 'A descrição não pode ficar vazia.';
          }
          if (label == 'Bairro' && (value == null || value.trim().isEmpty)) {
            return 'Informe o bairro.';
          }
          return null;
        },
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.itemLabel,
    this.enabled = true,
  });

  final String label;
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T value) itemLabel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(itemLabel(item)),
              ),
            )
            .toList(),
        onChanged: enabled ? onChanged : null,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.text, required this.icon});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4CC),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFB45309)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(color: Color(0xFF7C2D12)))),
        ],
      ),
    );
  }
}