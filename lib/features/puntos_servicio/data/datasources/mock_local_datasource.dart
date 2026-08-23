import 'package:app_puntos_acceso/features/puntos_servicio/domain/entities/punto_servicio.dart';

import '../models/punto_servicio_model.dart';
import 'punto_servicio_datasource.dart';

/// Fuente de datos local (mock). Implementa la misma "forma" que tendrá
/// más adelante el datasource remoto (que consumirá GET /puntos),
/// para poder intercambiarlos en el repositorio sin tocar el resto de capas.
class MockLocalDatasource implements PuntoServicioDatasource {
  @override
  Future<List<PuntoServicioModel>> obtenerPuntos() async {
    // Simula latencia de red para que el manejo de estado (loading) sea real.
    await Future.delayed(const Duration(milliseconds: 300));
    return _puntosMock;
  }

  @override
  Future<PuntoServicioModel?> obtenerPuntoPorId(int id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return _puntosMock.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  final List<PuntoServicioModel> _puntosMock = [
    PuntoServicioModel(
      id: 1,
      nombre: 'Mantenimiento Centro Norte',
      descripcion:
          'Mantenimiento preventivo de infraestructura en la zona centro-norte de la ciudad.',
      categoria: CategoriaPunto.mantenimiento,
      zona: 'Zona 03',
      latitud: 20.5211,
      longitud: -100.8158,
      costoEstimado: 185000,
      personasAtendidas: 75,
      fechaInicio: DateTime(2026, 6, 1),
      fechaTermino: DateTime(2026, 7, 15),
      estado: EstadoPunto.enProceso,
      responsablePrincipal: 'Ing. Laura Medina',
      supervisor: 'Carlos Reyes',
      tecnicoAsignado: 'Jorge Pantoja',
      proveedorExterno: 'Servicios Técnicos del Bajío S.A. de C.V.',
      evidencias: const [
        'https://picsum.photos/seed/punto1a/600/400',
        'https://picsum.photos/seed/punto1b/600/400',
        'https://picsum.photos/seed/punto1c/600/400',
      ],
    ),
    PuntoServicioModel(
      id: 2,
      nombre: 'Instalación Eléctrica Zona Industrial',
      descripcion:
          'Instalación de nuevo tablero eléctrico para el parque industrial sur.',
      categoria: CategoriaPunto.instalacion,
      zona: 'Zona 01',
      latitud: 20.5461,
      longitud: -100.7940,
      costoEstimado: 320000,
      personasAtendidas: 40,
      fechaInicio: DateTime(2026, 7, 1),
      fechaTermino: DateTime(2026, 8, 20),
      estado: EstadoPunto.pendiente,
      responsablePrincipal: 'Ing. Roberto Salinas',
      supervisor: 'Ana Belén Torres',
      tecnicoAsignado: 'Miguel Ángel Cruz',
      proveedorExterno: 'Electro Instalaciones Guanajuato',
      evidencias: const [
        'https://picsum.photos/seed/punto2a/600/400',
        'https://picsum.photos/seed/punto2b/600/400',
        'https://picsum.photos/seed/punto2c/600/400',
      ],
    ),
    PuntoServicioModel(
      id: 3,
      nombre: 'Inspección Estructural Puente Sur',
      descripcion:
          'Inspección de condiciones estructurales del puente vehicular sur.',
      categoria: CategoriaPunto.inspeccion,
      zona: 'Zona 02',
      latitud: 20.4995,
      longitud: -100.8305,
      costoEstimado: 95000,
      personasAtendidas: 0,
      fechaInicio: DateTime(2026, 5, 10),
      fechaTermino: DateTime(2026, 5, 12),
      estado: EstadoPunto.terminado,
      responsablePrincipal: 'Ing. Patricia Loyola',
      supervisor: 'Fernando Aguirre',
      tecnicoAsignado: 'Diego Ramírez',
      proveedorExterno: 'Consultores Estructurales del Centro',
      evidencias: const [
        'https://picsum.photos/seed/punto3a/600/400',
        'https://picsum.photos/seed/punto3b/600/400',
        'https://picsum.photos/seed/punto3c/600/400',
      ],
    ),
    PuntoServicioModel(
      id: 4,
      nombre: 'Reparación de Drenaje Colonia Alameda',
      descripcion: 'Reparación de fuga en línea principal de drenaje.',
      categoria: CategoriaPunto.reparacion,
      zona: 'Zona 04',
      latitud: 20.5350,
      longitud: -100.8420,
      costoEstimado: 68000,
      personasAtendidas: 210,
      fechaInicio: DateTime(2026, 8, 1),
      fechaTermino: DateTime(2026, 8, 10),
      estado: EstadoPunto.enProceso,
      responsablePrincipal: 'Ing. Héctor Villanueva',
      supervisor: 'Gabriela Ponce',
      tecnicoAsignado: 'Luis Fernando Ibarra',
      proveedorExterno: 'Aguas y Drenajes del Bajío',
      evidencias: const [
        'https://picsum.photos/seed/punto4a/600/400',
        'https://picsum.photos/seed/punto4b/600/400',
        'https://picsum.photos/seed/punto4c/600/400',
      ],
    ),
    PuntoServicioModel(
      id: 5,
      nombre: 'Proyecto Especial Centro Cultural',
      descripcion:
          'Remodelación integral del centro cultural comunitario, incluye accesibilidad.',
      categoria: CategoriaPunto.proyectoEspecial,
      zona: 'Zona 03',
      latitud: 20.5180,
      longitud: -100.8070,
      costoEstimado: 540000,
      personasAtendidas: 300,
      fechaInicio: DateTime(2026, 4, 15),
      fechaTermino: DateTime(2026, 9, 30),
      estado: EstadoPunto.enProceso,
      responsablePrincipal: 'Arq. Sofía Nieto',
      supervisor: 'Ricardo Bautista',
      tecnicoAsignado: 'Andrea Palacios',
      proveedorExterno: 'Constructora Bajío Renace',
      evidencias: const [
        'https://picsum.photos/seed/punto5a/600/400',
        'https://picsum.photos/seed/punto5b/600/400',
        'https://picsum.photos/seed/punto5c/600/400',
      ],
    ),
    PuntoServicioModel(
      id: 6,
      nombre: 'Mantenimiento Parque Zona Oriente',
      descripcion:
          'Mantenimiento de áreas verdes y luminarias del parque público oriente.',
      categoria: CategoriaPunto.mantenimiento,
      zona: 'Zona 02',
      latitud: 20.5040,
      longitud: -100.7890,
      costoEstimado: 47000,
      personasAtendidas: 500,
      fechaInicio: DateTime(2026, 6, 20),
      fechaTermino: DateTime(2026, 6, 25),
      estado: EstadoPunto.pendiente,
      responsablePrincipal: 'Ing. Marco Antonio Reséndiz',
      supervisor: 'Daniela Cortés',
      tecnicoAsignado: 'Sergio Aranda',
      proveedorExterno: 'Jardinería y Espacios Verdes S.A.',
      evidencias: const [
        'https://picsum.photos/seed/punto6a/600/400',
        'https://picsum.photos/seed/punto6b/600/400',
        'https://picsum.photos/seed/punto6c/600/400',
      ],
    ),
  ];
}
