/// URL base de la API.
///
/// IMPORTANTE - "localhost" no significa lo mismo dentro de un emulador:
/// - Emulador Android: usa 10.0.2.2 (así el emulador ve tu máquina host).
/// - Simulador iOS: 127.0.0.1 funciona igual que en tu máquina.
/// - Dispositivo físico: usa la IP de tu máquina en la red local (ej. 192.168.x.x)
///   y asegúrate de correr uvicorn con --host 0.0.0.0.
const String kApiBaseUrl = 'http://127.0.0.1:8000';
