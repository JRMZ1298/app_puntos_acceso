import '../models/punto_servicio_model.dart';

/// Contrato común para cualquier fuente de datos de puntos de servicio
/// (mock local o API remota). El repositorio depende de esta abstracción,
/// no de una implementación concreta.
abstract class PuntoServicioDatasource {
  Future<List<PuntoServicioModel>> obtenerPuntos();
  Future<PuntoServicioModel?> obtenerPuntoPorId(int id);
}
