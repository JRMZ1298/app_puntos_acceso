/// Resultado de preguntarle a la API si hubo una intervención similar
/// en los últimos 60 días.
class ResultadoVerificacionIntervencion {
  final bool coincidencia;
  final DateTime? ultimaIntervencion;
  final String? tipo;
  final int? diasTranscurridos;

  const ResultadoVerificacionIntervencion({
    required this.coincidencia,
    this.ultimaIntervencion,
    this.tipo,
    this.diasTranscurridos,
  });

  factory ResultadoVerificacionIntervencion.fromJson(
    Map<String, dynamic> json,
  ) {
    return ResultadoVerificacionIntervencion(
      coincidencia: json['coincidencia'] as bool,
      ultimaIntervencion: json['ultimaIntervencion'] != null
          ? DateTime.parse(json['ultimaIntervencion'] as String)
          : null,
      tipo: json['tipo'] as String?,
      diasTranscurridos: json['diasTranscurridos'] as int?,
    );
  }
}
