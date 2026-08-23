import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/punto_servicio.dart';
import '../screens/detalle_screen.dart';

/// Muestra el bottom sheet con la info rápida del punto (Requerimiento 3).
Future<void> mostrarTarjetaPunto(BuildContext context, PuntoServicio punto) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => PuntoBottomSheet(punto: punto),
  );
}

class PuntoBottomSheet extends StatelessWidget {
  final PuntoServicio punto;

  const PuntoBottomSheet({super.key, required this.punto});

  @override
  Widget build(BuildContext context) {
    final formatoMoneda = NumberFormat.currency(locale: 'es_MX', symbol: r'$');
    final formatoFecha = DateFormat('dd/MM/yyyy');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    punto.nombre,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _ChipEstado(estado: punto.estado),
              ],
            ),
            const SizedBox(height: 12),
            _FilaDato(
              icono: Icons.category_outlined,
              etiqueta: 'Categoría',
              valor: punto.categoria.label,
            ),
            _FilaDato(
              icono: Icons.place_outlined,
              etiqueta: 'Zona',
              valor: punto.zona,
            ),
            _FilaDato(
              icono: Icons.payments_outlined,
              etiqueta: 'Costo',
              valor: formatoMoneda.format(punto.costoEstimado),
            ),
            _FilaDato(
              icono: Icons.groups_outlined,
              etiqueta: 'Personas atendidas',
              valor: '${punto.personasAtendidas}',
            ),
            _FilaDato(
              icono: Icons.event_outlined,
              etiqueta: 'Fecha',
              valor:
                  '${formatoFecha.format(punto.fechaInicio)} - ${formatoFecha.format(punto.fechaTermino)}',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(); // cierra el bottom sheet
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => DetalleScreen(punto: punto),
                    ),
                  );
                },
                child: const Text('VER DETALLE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilaDato extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String valor;

  const _FilaDato({
    required this.icono,
    required this.etiqueta,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icono, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          Text(
            '$etiqueta: ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(child: Text(valor)),
        ],
      ),
    );
  }
}

class _ChipEstado extends StatelessWidget {
  final EstadoPunto estado;

  const _ChipEstado({required this.estado});

  Color _color() {
    switch (estado) {
      case EstadoPunto.pendiente:
        return Colors.orange;
      case EstadoPunto.enProceso:
        return Colors.blue;
      case EstadoPunto.terminado:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        estado.label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
