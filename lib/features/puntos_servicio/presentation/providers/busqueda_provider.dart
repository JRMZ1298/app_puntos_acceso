import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Texto de búsqueda actual (Requerimiento 6). Se combina con
/// [filtrosProvider] dentro de puntosFiltradosProvider.
final busquedaProvider = StateProvider<String>((ref) => '');
