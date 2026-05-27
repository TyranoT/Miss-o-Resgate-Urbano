import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/bairro.dart';
import '../../domain/entities/categoria.dart';
import '../../domain/entities/chamado.dart';
import '../../domain/entities/prioridade.dart';
import '../../domain/entities/responsavel.dart';
import '../../domain/entities/status.dart';
import '../providers/chamados_provider.dart';

/// Formulário para criar um novo chamado.
class CadastroChamadoPage extends StatefulWidget {
  const CadastroChamadoPage({super.key});

  @override
  State<CadastroChamadoPage> createState() => _CadastroChamadoPageState();
}

class _CadastroChamadoPageState extends State<CadastroChamadoPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();

  Categoria? _categoria;
  Prioridade? _prioridade;
  Status? _status;
  Bairro? _bairro;
  Responsavel? _responsavel;

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChamadosProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Novo chamado')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _campoTitulo(),
              const SizedBox(height: 12),
              _campoDescricao(),
              const SizedBox(height: 12),
              _dropdownCategoria(provider.categorias),
              const SizedBox(height: 12),
              _dropdownPrioridade(provider.prioridades),
              const SizedBox(height: 12),
              _dropdownStatus(provider.statusList),
              const SizedBox(height: 12),
              _dropdownBairro(provider.bairros),
              const SizedBox(height: 12),
              _dropdownResponsavel(provider.responsaveis),
              const SizedBox(height: 24),
              _botaoSalvar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoTitulo() => TextFormField(
        controller: _tituloController,
        decoration: const InputDecoration(labelText: 'Título *'),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Título é obrigatório';
          }
          return null;
        },
      );

  Widget _campoDescricao() => TextFormField(
        controller: _descricaoController,
        decoration: const InputDecoration(labelText: 'Descrição *'),
        maxLines: 3,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Descrição é obrigatória';
          }
          return null;
        },
      );

  Widget _dropdownCategoria(List<Categoria> categorias) =>
      DropdownButtonFormField<Categoria>(
        value: _categoria,
        decoration: const InputDecoration(labelText: 'Categoria *'),
        items: categorias
            .map((c) => DropdownMenuItem(value: c, child: Text(c.nome)))
            .toList(),
        onChanged: (value) => setState(() => _categoria = value),
        validator: (value) => value == null ? 'Selecione uma categoria' : null,
      );

  Widget _dropdownPrioridade(List<Prioridade> prioridades) =>
      DropdownButtonFormField<Prioridade>(
        value: _prioridade,
        decoration: const InputDecoration(labelText: 'Prioridade *'),
        items: prioridades
            .map((p) => DropdownMenuItem(value: p, child: Text(p.nome)))
            .toList(),
        onChanged: (value) => setState(() => _prioridade = value),
        validator: (value) => value == null ? 'Selecione uma prioridade' : null,
      );

  Widget _dropdownStatus(List<Status> statusList) =>
      DropdownButtonFormField<Status>(
        value: _status,
        decoration: const InputDecoration(labelText: 'Status *'),
        items: statusList
            .map((s) => DropdownMenuItem(value: s, child: Text(s.nome)))
            .toList(),
        onChanged: (value) => setState(() => _status = value),
        validator: (value) => value == null ? 'Selecione um status' : null,
      );

  Widget _dropdownBairro(List<Bairro> bairros) =>
      DropdownButtonFormField<Bairro>(
        value: _bairro,
        decoration: const InputDecoration(labelText: 'Bairro *'),
        items: bairros
            .map((b) => DropdownMenuItem(value: b, child: Text(b.nome)))
            .toList(),
        onChanged: (value) => setState(() => _bairro = value),
        validator: (value) => value == null ? 'Selecione um bairro' : null,
      );

  Widget _dropdownResponsavel(List<Responsavel> responsaveis) =>
      DropdownButtonFormField<Responsavel>(
        value: _responsavel,
        decoration: const InputDecoration(labelText: 'Responsável'),
        items: responsaveis
            .map((r) => DropdownMenuItem(value: r, child: Text(r.nome)))
            .toList(),
        onChanged: (value) => setState(() => _responsavel = value),
      );

  Widget _botaoSalvar() => FilledButton.icon(
        onPressed: _salvar,
        icon: const Icon(Icons.save),
        label: const Text('Salvar chamado'),
      );

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final agora = DateTime.now();
    final chamado = Chamado(
      titulo: _tituloController.text.trim(),
      descricao: _descricaoController.text.trim(),
      categoria: _categoria!,
      prioridade: _prioridade!,
      status: _status!,
      bairro: _bairro!,
      responsavel: _responsavel,
      dataAbertura: agora,
      dataAtualizacao: agora,
    );

    final provider = context.read<ChamadosProvider>();
    final sucesso = await provider.criar(chamado);

    if (!mounted) return;

    if (sucesso) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chamado registrado com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.erro ?? 'Erro ao salvar.')),
      );
    }
  }
}
