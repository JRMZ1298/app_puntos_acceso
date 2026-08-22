import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/mock_local_datasource.dart';
import '../../data/repositories/punto_servicio_repository_impl.dart';
import '../../domain/entities/punto_servicio.dart';
import '../../domain/repositories/punto_servicio_repository.dart';

/// Datasource como provider para poder mockearlo/reemplazarlo en tests.
final mockLocalDatasourceProvider = Provider<MockLocalDatasource>((ref) {
  return MockLocalDatasource();
});

/// Repositorio expuesto vía su contrato abstracto (domain), no vía su
/// implementación concreta: la presentación depende de la abstracción.
final puntoServicioRepositoryProvider = Provider<PuntoServicioRepository>((
  ref,
) {
  final datasource = ref.watch(mockLocalDatasourceProvider);
  return PuntoServicioRepositoryImpl(datasource);
});

/// Estado asíncrono con la lista completa de puntos (sin filtrar).
/// La pantalla del mapa observa este provider para pintar los marcadores.
final puntosServicioProvider = FutureProvider<List<PuntoServicio>>((ref) async {
  final repository = ref.watch(puntoServicioRepositoryProvider);
  return repository.obtenerPuntos();
});
