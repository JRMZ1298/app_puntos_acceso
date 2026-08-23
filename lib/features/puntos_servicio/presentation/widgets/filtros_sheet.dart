import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/punto_servicio.dart';
import '../providers/filtros_provider.dart';

const List<String> _zonasDisponibles = [
  'Zona 01',
  'Zona 02',
  'Zona 03',
  'Zona 04',
];

Future<void> mostrarFiltros(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => const FiltrosSheet(),
  );
}

class FiltrosSheet extends ConsumerWidget {
  const FiltrosSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtros = ref.watch(filtrosProvider);
    final notifier = ref.read(filtrosProvider.notifier);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filtros', style: Theme.of(context).textTheme.titleLarge),
                TextButton(
                  onPressed: notifier.limpiarTodo,
                  child: const Text('Limpiar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Categoría', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: CategoriaPunto.values.map((categoria) {
                final seleccionado = filtros.categoria == categoria;
                return ChoiceChip(
                  label: Text(categoria.label),
                  selected: seleccionado,
                  onSelected: (_) =>
                      notifier.setCategoria(seleccionado ? null : categoria),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text('Estado', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: EstadoPunto.values.map((estado) {
                final seleccionado = filtros.estado == estado;
                return ChoiceChip(
                  label: Text(estado.label),
                  selected: seleccionado,
                  onSelected: (_) =>
                      notifier.setEstado(seleccionado ? null : estado),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text('Zona', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _zonasDisponibles.map((zona) {
                final seleccionado = filtros.zona == zona;
                return ChoiceChip(
                  label: Text(zona),
                  selected: seleccionado,
                  onSelected: (_) =>
                      notifier.setZona(seleccionado ? null : zona),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('APLICAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
