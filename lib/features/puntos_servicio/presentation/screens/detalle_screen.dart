import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/punto_servicio.dart';

/// Pantalla de detalle completo (Requerimiento 4).
class DetalleScreen extends StatelessWidget {
  final PuntoServicio punto;

  const DetalleScreen({super.key, required this.punto});

  @override
  Widget build(BuildContext context) {
    final formatoMoneda = NumberFormat.currency(locale: 'es_MX', symbol: r'$');

    return Scaffold(
      appBar: AppBar(title: Text(punto.nombre)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _Seccion(
            titulo: 'Información general',
            hijos: [
              _FilaDetalle(etiqueta: 'Nombre', valor: punto.nombre),
              _FilaDetalle(etiqueta: 'Descripción', valor: punto.descripcion),
              _FilaDetalle(etiqueta: 'Zona', valor: punto.zona),
              _FilaDetalle(
                etiqueta: 'Coordenadas',
                valor: '${punto.latitud}, ${punto.longitud}',
              ),
            ],
          ),
          _Seccion(
            titulo: 'Información económica',
            hijos: [
              _FilaDetalle(
                etiqueta: 'Costo total',
                valor: formatoMoneda.format(punto.costoEstimado),
              ),
            ],
          ),
          _Seccion(
            titulo: 'Usuarios atendidos',
            hijos: [
              _FilaDetalle(
                etiqueta: 'Total',
                valor: '${punto.personasAtendidas} personas',
              ),
            ],
          ),
          _Seccion(
            titulo: 'Responsables',
            hijos: [
              _FilaDetalle(
                etiqueta: 'Responsable principal',
                valor: punto.responsablePrincipal,
              ),
              _FilaDetalle(etiqueta: 'Supervisor', valor: punto.supervisor),
              _FilaDetalle(
                etiqueta: 'Técnico asignado',
                valor: punto.tecnicoAsignado,
              ),
              _FilaDetalle(
                etiqueta: 'Proveedor externo',
                valor: punto.proveedorExterno,
              ),
            ],
          ),
          _Seccion(
            titulo: 'Evidencias',
            hijos: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: punto.evidencias.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    punto.evidencias[index],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image_outlined)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  final String titulo;
  final List<Widget> hijos;

  const _Seccion({required this.titulo, required this.hijos});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...hijos,
          ],
        ),
      ),
    );
  }
}

class _FilaDetalle extends StatelessWidget {
  final String etiqueta;
  final String valor;

  const _FilaDetalle({required this.etiqueta, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: '$etiqueta: ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: valor),
          ],
        ),
      ),
    );
  }
}
