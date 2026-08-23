import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/busqueda_provider.dart';

class BarraBusqueda extends ConsumerWidget {
  const BarraBusqueda({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar por nombre, zona o categoría',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: ref.watch(busquedaProvider).isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () =>
                      ref.read(busquedaProvider.notifier).state = '',
                )
              : null,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (texto) => ref.read(busquedaProvider.notifier).state = texto,
      ),
    );
  }
}
