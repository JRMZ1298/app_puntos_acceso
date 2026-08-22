import '../entities/punto_servicio.dart';

/// Contrato que define domain. No sabe si los datos vienen de un mock,
/// de una API o de una base local: eso lo decide la implementación en data/.
abstract class PuntoServicioRepository {
  Future<List<PuntoServicio>> obtenerPuntos();
  Future<PuntoServicio?> obtenerPuntoPorId(int id);
}
