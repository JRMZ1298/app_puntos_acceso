import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../models/punto_servicio_model.dart';
import 'punto_servicio_datasource.dart';

/// Excepción específica de este datasource, para que capas superiores
/// puedan distinguir errores de red de otros tipos de error si lo necesitan.
class PuntoServicioRemoteException implements Exception {
  final String mensaje;
  PuntoServicioRemoteException(this.mensaje);

  @override
  String toString() => 'PuntoServicioRemoteException: $mensaje';
}

/// Fuente de datos remota: consume la API FastAPI de la Parte 3
/// (GET /puntos, GET /puntos/{id}). Cumple el mismo contrato que
/// [MockLocalDatasource], así que el repositorio puede usar cualquiera
/// de los dos sin cambiar una sola línea.
class RemoteDatasource implements PuntoServicioDatasource {
  final http.Client _client;
  final String _baseUrl;

  RemoteDatasource({http.Client? client, String baseUrl = kApiBaseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = baseUrl;

  @override
  Future<List<PuntoServicioModel>> obtenerPuntos() async {
    final uri = Uri.parse('$_baseUrl/puntos');
    try {
      final respuesta = await _client
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (respuesta.statusCode != 200) {
        throw PuntoServicioRemoteException(
          'La API respondió ${respuesta.statusCode} al pedir /puntos',
        );
      }

      final List<dynamic> data = jsonDecode(utf8.decode(respuesta.bodyBytes));
      return data
          .map(
            (json) => PuntoServicioModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on PuntoServicioRemoteException {
      rethrow;
    } catch (e) {
      throw PuntoServicioRemoteException('No se pudo conectar a la API: $e');
    }
  }

  @override
  Future<PuntoServicioModel?> obtenerPuntoPorId(int id) async {
    final uri = Uri.parse('$_baseUrl/puntos/$id');
    try {
      final respuesta = await _client
          .get(uri)
          .timeout(const Duration(seconds: 10));

      if (respuesta.statusCode == 404) {
        return null;
      }
      if (respuesta.statusCode != 200) {
        throw PuntoServicioRemoteException(
          'La API respondió ${respuesta.statusCode} al pedir /puntos/$id',
        );
      }

      final json =
          jsonDecode(utf8.decode(respuesta.bodyBytes)) as Map<String, dynamic>;
      return PuntoServicioModel.fromJson(json);
    } on PuntoServicioRemoteException {
      rethrow;
    } catch (e) {
      throw PuntoServicioRemoteException('No se pudo conectar a la API: $e');
    }
  }
}
