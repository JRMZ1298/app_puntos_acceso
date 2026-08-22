import '../../domain/entities/punto_servicio.dart';
import '../../domain/repositories/punto_servicio_repository.dart';
import '../datasources/mock_local_datasource.dart';

/// Implementación concreta. Por ahora usa [MockLocalDatasource]; cuando se
/// conecte la API de la Parte 3, solo se cambia la fuente aquí adentro
/// (o se inyecta un RemoteDatasource) sin tocar domain ni presentation.
class PuntoServicioRepositoryImpl implements PuntoServicioRepository {
  final MockLocalDatasource _datasource;

  PuntoServicioRepositoryImpl(this._datasource);

  @override
  Future<List<PuntoServicio>> obtenerPuntos() async {
    // Simula latencia de red para que el manejo de estado (loading) sea real.
    await Future.delayed(const Duration(milliseconds: 300));
    return _datasource.obtenerPuntos();
  }

  @override
  Future<PuntoServicio?> obtenerPuntoPorId(int id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final puntos = _datasource.obtenerPuntos();
    try {
      return puntos.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
