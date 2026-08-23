import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/punto_servicio.dart';

/// Valor inmutable con los filtros activos. Todos nulos = sin filtro.
class FiltrosPuntos {
  final CategoriaPunto? categoria;
  final EstadoPunto? estado;
  final String? zona;

  const FiltrosPuntos({this.categoria, this.estado, this.zona});

  bool get tieneFiltrosActivos =>
      categoria != null || estado != null || zona != null;

  FiltrosPuntos copyWith({
    CategoriaPunto? categoria,
    bool limpiarCategoria = false,
    EstadoPunto? estado,
    bool limpiarEstado = false,
    String? zona,
    bool limpiarZona = false,
  }) {
    return FiltrosPuntos(
      categoria: limpiarCategoria ? null : (categoria ?? this.categoria),
      estado: limpiarEstado ? null : (estado ?? this.estado),
      zona: limpiarZona ? null : (zona ?? this.zona),
    );
  }
}

class FiltrosNotifier extends StateNotifier<FiltrosPuntos> {
  FiltrosNotifier() : super(const FiltrosPuntos());

  void setCategoria(CategoriaPunto? categoria) {
    state = state.copyWith(
      categoria: categoria,
      limpiarCategoria: categoria == null,
    );
  }

  void setEstado(EstadoPunto? estado) {
    state = state.copyWith(estado: estado, limpiarEstado: estado == null);
  }

  void setZona(String? zona) {
    state = state.copyWith(zona: zona, limpiarZona: zona == null);
  }

  void limpiarTodo() {
    state = const FiltrosPuntos();
  }
}

final filtrosProvider = StateNotifierProvider<FiltrosNotifier, FiltrosPuntos>((
  ref,
) {
  return FiltrosNotifier();
});
