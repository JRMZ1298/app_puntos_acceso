import '../../domain/entities/punto_servicio.dart';

/// Modelo de datos: sabe convertirse desde/hacia JSON.
/// Extiende la entidad de dominio para poder usarse indistintamente
/// donde se espera un [PuntoServicio], sin duplicar campos.
class PuntoServicioModel extends PuntoServicio {
  const PuntoServicioModel({
    required super.id,
    required super.nombre,
    required super.descripcion,
    required super.categoria,
    required super.zona,
    required super.latitud,
    required super.longitud,
    required super.costoEstimado,
    required super.personasAtendidas,
    required super.fechaInicio,
    required super.fechaTermino,
    required super.estado,
    required super.responsablePrincipal,
    required super.supervisor,
    required super.tecnicoAsignado,
    required super.proveedorExterno,
    required super.evidencias,
  });

  factory PuntoServicioModel.fromJson(Map<String, dynamic> json) {
    return PuntoServicioModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String? ?? '',
      categoria: CategoriaPunto.fromLabel(json['categoria'] as String),
      zona: json['zona'] as String,
      latitud: (json['latitud'] as num).toDouble(),
      longitud: (json['longitud'] as num).toDouble(),
      costoEstimado: (json['costo'] as num).toDouble(),
      personasAtendidas: json['personasAtendidas'] as int,
      fechaInicio: DateTime.parse(json['fechaInicio'] as String),
      fechaTermino: DateTime.parse(json['fechaTermino'] as String),
      estado: EstadoPunto.fromLabel(json['estado'] as String),
      responsablePrincipal: json['responsablePrincipal'] as String? ?? '',
      supervisor: json['supervisor'] as String? ?? '',
      tecnicoAsignado: json['tecnicoAsignado'] as String? ?? '',
      proveedorExterno: json['proveedorExterno'] as String? ?? '',
      evidencias: (json['evidencias'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoria.label,
      'zona': zona,
      'latitud': latitud,
      'longitud': longitud,
      'costo': costoEstimado,
      'personasAtendidas': personasAtendidas,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaTermino': fechaTermino.toIso8601String(),
      'estado': estado.label,
      'responsablePrincipal': responsablePrincipal,
      'supervisor': supervisor,
      'tecnicoAsignado': tecnicoAsignado,
      'proveedorExterno': proveedorExterno,
      'evidencias': evidencias,
    };
  }
}
