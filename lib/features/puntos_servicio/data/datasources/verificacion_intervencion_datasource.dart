import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/resultado_verificacion_intervencion.dart';

/// Consume el endpoint del reto de lógica: POST /intervenciones/verificar.
class VerificacionIntervencionDatasource {
  final http.Client _client;
  final String _baseUrl;

  VerificacionIntervencionDatasource({
    http.Client? client,
    String baseUrl = kApiBaseUrl,
  }) : _client = client ?? http.Client(),
       _baseUrl = baseUrl;

  Future<ResultadoVerificacionIntervencion> verificar({
    required int idPunto,
    required String tipoIntervencion,
    required DateTime fechaActual,
  }) async {
    final uri = Uri.parse('$_baseUrl/intervenciones/verificar');
    final fecha =
        '${fechaActual.year.toString().padLeft(4, '0')}-${fechaActual.month.toString().padLeft(2, '0')}-${fechaActual.day.toString().padLeft(2, '0')}';

    final respuesta = await _client
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'idPunto': idPunto,
            'tipoIntervencion': tipoIntervencion,
            'fechaActual': fecha,
          }),
        )
        .timeout(const Duration(seconds: 10));

    if (respuesta.statusCode != 200) {
      throw Exception(
        'La API respondió ${respuesta.statusCode} al verificar la intervención',
      );
    }

    final json =
        jsonDecode(utf8.decode(respuesta.bodyBytes)) as Map<String, dynamic>;
    return ResultadoVerificacionIntervencion.fromJson(json);
  }
}
