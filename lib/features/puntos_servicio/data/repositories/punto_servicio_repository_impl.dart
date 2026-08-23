import '../../domain/entities/punto_servicio.dart';
import '../../domain/repositories/punto_servicio_repository.dart';
import '../datasources/punto_servicio_datasource.dart';

/// Implementación concreta. Recibe cualquier [PuntoServicioDatasource]
/// (mock o remoto) y delega en él; no sabe ni le importa cuál es.
class PuntoServicioRepositoryImpl implements PuntoServicioRepository {
  final PuntoServicioDatasource _datasource;

  PuntoServicioRepositoryImpl(this._datasource);

  @override
  Future<List<PuntoServicio>> obtenerPuntos() {
    return _datasource.obtenerPuntos();
  }

  @override
  Future<PuntoServicio?> obtenerPuntoPorId(int id) {
    return _datasource.obtenerPuntoPorId(id);
  }
}
