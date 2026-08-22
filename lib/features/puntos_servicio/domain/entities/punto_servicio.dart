/// Categorías permitidas para un punto de servicio (Requerimiento 5 - Filtros).
enum CategoriaPunto {
  instalacion('Instalación'),
  mantenimiento('Mantenimiento'),
  inspeccion('Inspección'),
  reparacion('Reparación'),
  proyectoEspecial('Proyecto especial');

  final String label;
  const CategoriaPunto(this.label);

  static CategoriaPunto fromLabel(String label) {
    return CategoriaPunto.values.firstWhere(
      (c) => c.label.toLowerCase() == label.toLowerCase(),
      orElse: () => CategoriaPunto.mantenimiento,
    );
  }
}

/// Estados permitidos para un punto de servicio (Requerimiento 5 - Filtros).
enum EstadoPunto {
  pendiente('Pendiente'),
  enProceso('En proceso'),
  terminado('Terminado');

  final String label;
  const EstadoPunto(this.label);

  static EstadoPunto fromLabel(String label) {
    return EstadoPunto.values.firstWhere(
      (e) => e.label.toLowerCase() == label.toLowerCase(),
      orElse: () => EstadoPunto.pendiente,
    );
  }
}

/// Entidad pura de dominio. No conoce JSON ni ningún detalle de infraestructura;
/// es lo que usan los casos de uso y la capa de presentación.
class PuntoServicio {
  final int id;
  final String nombre;
  final String descripcion;
  final CategoriaPunto categoria;
  final String zona;
  final double latitud;
  final double longitud;
  final double costoEstimado;
  final int personasAtendidas;
  final DateTime fechaInicio;
  final DateTime fechaTermino;
  final EstadoPunto estado;

  // Datos usados en la pantalla de detalle (Requerimiento 4)
  final String responsablePrincipal;
  final String supervisor;
  final String tecnicoAsignado;
  final String proveedorExterno;
  final List<String> evidencias; // URLs de imágenes (mínimo 3)

  const PuntoServicio({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.zona,
    required this.latitud,
    required this.longitud,
    required this.costoEstimado,
    required this.personasAtendidas,
    required this.fechaInicio,
    required this.fechaTermino,
    required this.estado,
    required this.responsablePrincipal,
    required this.supervisor,
    required this.tecnicoAsignado,
    required this.proveedorExterno,
    required this.evidencias,
  });
}
