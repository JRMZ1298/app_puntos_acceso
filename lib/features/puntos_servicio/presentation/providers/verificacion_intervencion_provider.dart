import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/verificacion_intervencion_datasource.dart';

final verificacionIntervencionDatasourceProvider =
    Provider<VerificacionIntervencionDatasource>((ref) {
      return VerificacionIntervencionDatasource();
    });
