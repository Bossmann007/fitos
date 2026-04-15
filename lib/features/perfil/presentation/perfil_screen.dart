// lib/features/perfil/presentation/perfil_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/entities/profile.dart';
import 'providers/profile_provider.dart';

class PerfilScreen extends ConsumerStatefulWidget {
  const PerfilScreen({super.key});

  @override
  ConsumerState<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends ConsumerState<PerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileStateProvider);
    if (profile != null) {
      _nameController.text = profile.name;
      _ageController.text = profile.age.toString();
      _weightController.text = profile.weight.toString();
      _heightController.text = profile.height.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(profileStateProvider.notifier).save(
          Profile(
            name: _nameController.text.trim(),
            age: int.parse(_ageController.text),
            weight: double.parse(_weightController.text),
            height: double.parse(_heightController.text),
          ),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil salvo!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileStateProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (profile != null) ...[
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _statChip(context, 'Peso', '${profile.weight} kg'),
                        _statChip(context, 'Altura', '${profile.height} cm'),
                        _statChip(context, 'IMC', profile.imc.toStringAsFixed(1)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe seu nome' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Idade',
                        border: OutlineInputBorder(),
                        suffixText: 'anos',
                      ),
                      validator: (v) =>
                          int.tryParse(v ?? '') == null ? 'Inválido' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Peso',
                        border: OutlineInputBorder(),
                        suffixText: 'kg',
                      ),
                      validator: (v) =>
                          double.tryParse(v ?? '') == null ? 'Inválido' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Altura',
                  border: OutlineInputBorder(),
                  suffixText: 'cm',
                ),
                validator: (v) =>
                    double.tryParse(v ?? '') == null ? 'Inválido' : null,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text('Salvar Perfil'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statChip(BuildContext context, String label, String value) => Column(
        children: [
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      );
}
