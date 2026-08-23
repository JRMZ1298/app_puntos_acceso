import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/mock_local_datasource.dart';
import '../../data/datasources/punto_servicio_datasource.dart';
import '../../data/datasources/remote_datasource.dart';
import '../../data/repositories/punto_servicio_repository_impl.dart';
import '../../domain/entities/punto_servicio.dart';
import '../../domain/repositories/punto_servicio_repository.dart';
import 'busqueda_provider.dart';
import 'filtros_provider.dart';

/// Interruptor mock/API real. En `false` usa el mock local; cámbialo a
/// `true` (o expón un switch en la UI) para consumir la API de FastAPI
/// de la Parte 3 sin tocar ninguna otra capa.
final usarApiRemotaProvider = Provider<bool>((ref) => true);

final mockLocalDatasourceProvider = Provider<MockLocalDatasource>((ref) {
  return MockLocalDatasource();
});

final remoteDatasourceProvider = Provider<RemoteDatasource>((ref) {
  return RemoteDatasource();
});

/// Elige el datasource activo según [usarApiRemotaProvider].
final puntoServicioDatasourceProvider = Provider<PuntoServicioDatasource>((
  ref,
) {
  final usarApiRemota = ref.watch(usarApiRemotaProvider);
  return usarApiRemota
      ? ref.watch(remoteDatasourceProvider)
      : ref.watch(mockLocalDatasourceProvider);
});

/// Repositorio expuesto vía su contrato abstracto (domain), no vía su
/// implementación concreta: la presentación depende de la abstracción.
final puntoServicioRepositoryProvider = Provider<PuntoServicioRepository>((
  ref,
) {
  final datasource = ref.watch(puntoServicioDatasourceProvider);
  return PuntoServicioRepositoryImpl(datasource);
});

/// Estado asíncrono con la lista completa de puntos (sin filtrar).
/// La pantalla del mapa observa este provider para pintar los marcadores.
final puntosServicioProvider = FutureProvider<List<PuntoServicio>>((ref) async {
  final repository = ref.watch(puntoServicioRepositoryProvider);
  return repository.obtenerPuntos();
});

/// Lista de puntos ya filtrada según [filtrosProvider]. La UI (mapa, lista)
/// debe observar este provider en lugar de [puntosServicioProvider]
/// directamente para respetar los filtros activos.
final puntosFiltradosProvider = Provider<AsyncValue<List<PuntoServicio>>>((
  ref,
) {
  final puntosAsync = ref.watch(puntosServicioProvider);
  final filtros = ref.watch(filtrosProvider);
  final busqueda = ref.watch(busquedaProvider).trim().toLowerCase();

  return puntosAsync.whenData((puntos) {
    return puntos.where((punto) {
      final coincideCategoria =
          filtros.categoria == null || punto.categoria == filtros.categoria;
      final coincideEstado =
          filtros.estado == null || punto.estado == filtros.estado;
      final coincideZona = filtros.zona == null || punto.zona == filtros.zona;

      final coincideBusqueda =
          busqueda.isEmpty ||
          punto.nombre.toLowerCase().contains(busqueda) ||
          punto.zona.toLowerCase().contains(busqueda) ||
          punto.categoria.label.toLowerCase().contains(busqueda);

      return coincideCategoria &&
          coincideEstado &&
          coincideZona &&
          coincideBusqueda;
    }).toList();
  });
});
