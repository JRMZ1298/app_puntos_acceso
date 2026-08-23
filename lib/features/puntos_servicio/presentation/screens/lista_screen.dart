import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/punto_servicio.dart';
import '../providers/filtros_provider.dart';
import '../providers/punto_servicio_providers.dart';
import '../widgets/barra_busqueda.dart';
import '../widgets/filtros_sheet.dart';
import 'detalle_screen.dart';

/// Vista en lista de los mismos puntos que se ven en el mapa.
/// Comparte búsqueda y filtros con MapaScreen porque observa los mismos providers.
class ListaScreen extends ConsumerWidget {
  const ListaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puntosAsync = ref.watch(puntosFiltradosProvider);
    final filtros = ref.watch(filtrosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de puntos'),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: filtros.tieneFiltrosActivos,
              child: const Icon(Icons.filter_list),
            ),
            tooltip: 'Filtros',
            onPressed: () => mostrarFiltros(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const BarraBusqueda(),
          Expanded(
            child: puntosAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text('Error: $error')),
              data: (puntos) {
                if (puntos.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay puntos que coincidan con la búsqueda o los filtros.',
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: puntos.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      _TarjetaPunto(punto: puntos[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaPunto extends StatelessWidget {
  final PuntoServicio punto;

  const _TarjetaPunto({required this.punto});

  Color _colorEstado(EstadoPunto estado) {
    switch (estado) {
      case EstadoPunto.pendiente:
        return Colors.orange;
      case EstadoPunto.enProceso:
        return Colors.blue;
      case EstadoPunto.terminado:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatoMoneda = NumberFormat.currency(locale: 'es_MX', symbol: r'$');

    return Card(
      child: ListTile(
        leading: Icon(Icons.location_on, color: _colorEstado(punto.estado)),
        title: Text(punto.nombre),
        subtitle: Text(
          '${punto.categoria.label} · ${punto.zona} · ${formatoMoneda.format(punto.costoEstimado)}',
        ),
        trailing: Text(
          punto.estado.label,
          style: TextStyle(color: _colorEstado(punto.estado)),
        ),
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => DetalleScreen(punto: punto))),
      ),
    );
  }
}
