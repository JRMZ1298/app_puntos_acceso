import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entities/punto_servicio.dart';
import '../providers/filtros_provider.dart';
import '../providers/punto_servicio_providers.dart';
import '../widgets/barra_busqueda.dart';
import '../widgets/filtros_sheet.dart';
import '../widgets/punto_bottom_sheet.dart';

class MapaScreen extends ConsumerWidget {
  const MapaScreen({super.key});

  // Centro aproximado de la zona donde están los puntos mock (Celaya, Gto).
  static const LatLng _centroInicial = LatLng(20.5211, -100.8158);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puntosAsync = ref.watch(puntosFiltradosProvider);
    final filtros = ref.watch(filtrosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Puntos de servicio'),
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
              error: (error, stackTrace) => Center(
                child: Text('Ocurrió un error al cargar los puntos: $error'),
              ),
              data: (puntos) {
                if (puntos.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay puntos que coincidan con la búsqueda o los filtros.',
                    ),
                  );
                }
                return FlutterMap(
                  options: const MapOptions(
                    initialCenter: _centroInicial,
                    initialZoom: 13,
                  ),
                  children: [
                    TileLayer(
                      // OpenStreetMap: sin API key, uso libre respetando su política de tiles.
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.puntos_servicio_app',
                    ),
                    MarkerLayer(
                      markers: puntos
                          .map((punto) => _construirMarcador(context, punto))
                          .toList(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Marker _construirMarcador(BuildContext context, PuntoServicio punto) {
    return Marker(
      point: LatLng(punto.latitud, punto.longitud),
      width: 44,
      height: 44,
      child: GestureDetector(
        onTap: () => mostrarTarjetaPunto(context, punto),
        child: Icon(
          Icons.location_on,
          size: 40,
          color: _colorPorEstado(punto.estado),
        ),
      ),
    );
  }

  Color _colorPorEstado(EstadoPunto estado) {
    switch (estado) {
      case EstadoPunto.pendiente:
        return Colors.orange;
      case EstadoPunto.enProceso:
        return Colors.blue;
      case EstadoPunto.terminado:
        return Colors.green;
    }
  }
}
