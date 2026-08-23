# Puntos de Servicio App

App móvil desarrollada en Flutter para la evaluación técnica de Desarrollador de Aplicaciones. Muestra en un mapa interactivo puntos de servicio distribuidos en distintas zonas de una ciudad, con búsqueda, filtros, tarjeta de detalle rápido y pantalla de detalle completo.

## Requisitos previos

- Flutter SDK `>=3.3.0`
- Un emulador Android/iOS configurado, o un dispositivo físico con depuración USB

## Instalación y ejecución

```bash
# 1. Clonar el repositorio
git clone <https://github.com/JRMZ1298/app_puntos_acceso.git>
cd puntos_servicio_app

# 2. Instalar dependencias
flutter pub get

# 3. Ejecutar en modo debug
flutter run

# 4. Generar el APK para entrega
flutter build apk --release
```

El APK generado queda en `build/app/outputs/flutter-apk/app-release.apk`.

## Arquitectura

El proyecto sigue **Clean Architecture** por feature, separando responsabilidades en tres capas dentro de `lib/features/puntos_servicio/`:

```
lib/
├── core/                     # utilidades, constantes, tema
└── features/
    └── puntos_servicio/
        ├── domain/            # reglas de negocio puras, sin dependencias externas
        │   ├── entities/      # PuntoServicio (entidad de dominio)
        │   └── repositories/  # PuntoServicioRepository (contrato abstracto)
        ├── data/              # implementación concreta del acceso a datos
        │   ├── models/        # PuntoServicioModel (fromJson/toJson)
        │   ├── datasources/   # MockLocalDatasource (fuente actual)
        │   └── repositories/  # PuntoServicioRepositoryImpl
        └── presentation/      # UI y manejo de estado
            ├── providers/     # Riverpod: datos, filtros, búsqueda
            ├── screens/       # HomeScreen, MapaScreen, ListaScreen, DetalleScreen, PerfilScreen
            └── widgets/       # BarraBusqueda, FiltrosSheet, PuntoBottomSheet
```

**Flujo de dependencias:** `presentation` → `domain` ← `data`. La capa `domain` no conoce Flutter ni JSON; `presentation` solo depende de las abstracciones de `domain` (nunca de `data` directamente), por lo que cambiar la fuente de datos (de mock a API real) no requiere tocar la UI.

### Navegación

`HomeScreen` contiene la `NavigationBar` inferior con 3 pestañas (`IndexedStack` para conservar el estado de cada una):

- **Mapa** — vista principal con `flutter_map`
- **Lista** — mismos puntos en formato lista, comparte búsqueda y filtros con el mapa
- **Perfil** — placeholder, fuera del alcance actual (se completará junto con autenticación/permisos)

## Dependencias

| Paquete            | Uso                                       |
| ------------------ | ----------------------------------------- |
| `flutter_riverpod` | Manejo de estado                          |
| `flutter_map`      | Mapa interactivo                          |
| `latlong2`         | Tipo `LatLng` requerido por `flutter_map` |
| `intl`             | Formato de moneda y fechas                |

## Decisiones técnicas

- **Mapa: `flutter_map` + OpenStreetMap**, en lugar de `google_maps_flutter`. Se eligió porque no requiere API key ni configuración de facturación en Google Cloud, lo que simplifica el setup dentro del tiempo del ejercicio, sin sacrificar interactividad (zoom, marcadores, tiles).
- **Gestor de estado: Riverpod**. Se eligió por ser testeable sin depender de `BuildContext`, evitar el uso de `InheritedWidget` manual, y por su soporte actual en el ecosistema Flutter. Se usan `FutureProvider` (carga async de datos), `Provider` (valores derivados/repositorio) y `StateNotifierProvider`/`StateProvider` (filtros y búsqueda).
- **Origen de datos: mock local primero**. Los 6 puntos ficticios viven en `MockLocalDatasource`. El repositorio (`PuntoServicioRepositoryImpl`) ya está diseñado contra la interfaz `PuntoServicioRepository`, así que conectar la API real de la Parte 3 implica solo agregar un `RemoteDatasource` e inyectarlo, sin tocar `domain` ni `presentation`.
- **Imágenes de evidencia: URLs de placeholder** (`picsum.photos`), en vez de assets locales, para no incrementar el peso del repositorio con imágenes de prueba.
- **Búsqueda y filtros combinados**: ambos se aplican sobre la misma lista base a través de un único provider derivado (`puntosFiltradosProvider`), evitando lógica duplicada entre la vista de mapa y la vista de lista.

## Estado actual

Completado (Parte 2 del examen):

- [x] Mapa interactivo con marcadores
- [x] Mínimo 6 puntos ficticios
- [x] Tarjeta inferior al tocar un marcador
- [x] Pantalla de detalle completo
- [x] Filtros por categoría, estado y zona
- [x] Búsqueda por nombre, zona y categoría
- [x] Navegación inferior (Mapa / Lista / Perfil)

Pendiente (otras partes del examen, fuera del alcance de este documento):

- [ ] API real (Parte 3)
- [ ] Diagrama entidad-relación (Parte 4)
- [ ] Función de coincidencia de intervención en 60 días (Parte 5)
- [ ] Permisos por rol (Parte 6)
