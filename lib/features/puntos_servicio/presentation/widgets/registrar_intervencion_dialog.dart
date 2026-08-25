import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/punto_servicio.dart';
import '../providers/verificacion_intervencion_provider.dart';

/// Punto de entrada: botón/acción que abre el flujo de "registrar intervención"
/// y, según la respuesta de la API, muestra la alerta de coincidencia (Parte 5).
Future<void> registrarIntervencion(
  BuildContext context,
  WidgetRef ref,
  PuntoServicio punto,
) async {
  final tipoSeleccionado = await showDialog<CategoriaPunto>(
    context: context,
    builder: (context) =>
        _SeleccionarTipoDialog(categoriaSugerida: punto.categoria),
  );

  if (tipoSeleccionado == null || !context.mounted) return;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    final datasource = ref.read(verificacionIntervencionDatasourceProvider);
    final resultado = await datasource.verificar(
      idPunto: punto.id,
      tipoIntervencion: tipoSeleccionado.label,
      fechaActual: DateTime.now(),
    );

    if (!context.mounted) return;
    Navigator.of(context).pop(); // cierra el loading

    if (resultado.coincidencia) {
      final formatoFecha = DateFormat('dd/MM/yyyy');
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 32,
          ),
          title: const Text('Posible intervención duplicada'),
          content: Text(
            'Este punto ya tuvo una intervención de tipo "${resultado.tipo}" '
            'hace ${resultado.diasTranscurridos} días '
            '(${formatoFecha.format(resultado.ultimaIntervencion!)}), '
            'dentro de los últimos 60 días.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ENTENDIDO'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sin intervenciones similares en los últimos 60 días.'),
        ),
      );
    }
  } catch (e) {
    if (!context.mounted) return;
    Navigator.of(context).pop(); // cierra el loading
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No se pudo verificar la intervención: $e')),
    );
  }
}

class _SeleccionarTipoDialog extends StatelessWidget {
  final CategoriaPunto categoriaSugerida;

  const _SeleccionarTipoDialog({required this.categoriaSugerida});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tipo de intervención'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: CategoriaPunto.values.map((categoria) {
          final esSugerida = categoria == categoriaSugerida;
          return ListTile(
            title: Text(categoria.label),
            leading: Icon(
              esSugerida
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: esSugerida ? Theme.of(context).colorScheme.primary : null,
            ),
            onTap: () => Navigator.of(context).pop(categoria),
          );
        }).toList(),
      ),
    );
  }
}
