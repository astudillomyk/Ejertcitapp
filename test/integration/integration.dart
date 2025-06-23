import 'package:flutter_test/flutter_test.dart';
import 'package:ejercitapp/models/tarea.dart';
import 'package:ejercitapp/services/tareas_service.dart';


void main() {
  group('Tests de Integración', () {
    late TareasService service;

    setUp(() async {
      service = TareasService();
      await service.cargarDatos();
    });

    tearDown(() async {
    });

    test('TI-01: El sistema muestra el clima de la tarea', () {
      final tarea = Tarea(
        id: 'clima1',
        nombre: 'Ejemplo tarea clima',
        categoria: 'Cardio',
        experiencia: 10.0,
        creadaEn: DateTime.now(),
        clima: 'Soleado',
      );
      service.agregarTarea(tarea);

      final t = service.tareas.firstWhere((t) => t.id == 'clima1');
      expect(t.clima, 'Soleado');
    });

    test('TI-02: Fotografías asociadas correctamente al completar tarea', () async {
      final tarea = Tarea(
        id: 'foto1',
        nombre: 'Tarea con foto',
        categoria: 'Fuerza',
        experiencia: 20.0,
        creadaEn: DateTime.now(),
      );
      service.agregarTarea(tarea);

      service.completarTarea('foto1', 'https://fake-url.com/foto.jpg');

      final t = service.tareas.firstWhere((t) => t.id == 'foto1');
      expect(t.imagenPath, contains('fake-url.com'));
      expect(t.completadaEn, isNotNull);
    });

    test('TI-03: Tareas eliminadas se agregan al historial', () {
      final tarea = Tarea(
        id: 'elim1',
        nombre: 'Tarea a eliminar',
        categoria: 'Cardio',
        experiencia: 15.0,
        creadaEn: DateTime.now(),
      );
      service.agregarTarea(tarea);
      service.eliminarTarea('elim1');

      expect(service.tareas.any((t) => t.id == 'elim1'), isFalse);
      expect(service.historial.any((t) => t.id == 'elim1'), isTrue);
    });

    test('TI-04: Subir fotografía almacena ruta en tarea', () async {
      final tarea = Tarea(
        id: 'subirFoto',
        nombre: 'Subir foto',
        categoria: 'Fuerza',
        experiencia: 15.0,
        creadaEn: DateTime.now(),
      );
      service.agregarTarea(tarea);

      service.completarTarea('subirFoto', 'https://fake-url.com/image.png');

      final t = service.tareas.firstWhere((t) => t.id == 'subirFoto');
      expect(t.imagenPath, 'https://fake-url.com/image.png');
    });

    test('TI-05 y TI-06: Crear y listar categorías', () {
      service.agregarCategoria('Yoga');
      service.agregarCategoria('Pilates');

      final categorias = service.categorias;
      expect(categorias.contains('Yoga'), isTrue);
      expect(categorias.contains('Pilates'), isTrue);
    });

    test('TI-07: Editar tarea refleja cambios sin modificar nombre ni experiencia', () {
  final tarea = Tarea(
    id: 'edit1',
    nombre: 'Tarea original',
    categoria: 'Cardio',
    experiencia: 10.0,
    creadaEn: DateTime.now(),
  );
  service.agregarTarea(tarea);

  final tareaEditada = Tarea(
    id: tarea.id,
    nombre: tarea.nombre,
    categoria: tarea.categoria,
    experiencia: tarea.experiencia,
    creadaEn: tarea.creadaEn,
    imagenPath: 'https://nuevaimagen.com/img.jpg',
    completadaEn: DateTime.now(),
    clima: 'Nublado',
  );

  service.actualizarTarea(tareaEditada);

  final t = service.tareas.firstWhere((t) => t.id == 'edit1');
  expect(t.nombre, 'Tarea original');
  expect(t.experiencia, 10.0); 
  expect(t.imagenPath, 'https://nuevaimagen.jpg');
  expect(t.clima, 'Nublado');
});


    test('TI-08: Eliminar tarea se refleja en historial', () {
      final tarea = Tarea(
        id: 'elim2',
        nombre: 'Eliminar tarea historial',
        categoria: 'Fuerza',
        experiencia: 25.0,
        creadaEn: DateTime.now(),
      );
      service.agregarTarea(tarea);
      service.eliminarTarea('elim2');

      expect(service.historial.any((t) => t.id == 'elim2'), isTrue);
      expect(service.tareas.any((t) => t.id == 'elim2'), isFalse);
    });

    test('TI-09: Simulación de obtener clima (mock)', () async {
      final climaSimulado = 'Nublado';
      expect(climaSimulado, isNotEmpty);
    });

    test('TI-010: Mostrar clima en detalle tarea', () {
      final tarea = Tarea(
        id: 'detalleClima',
        nombre: 'Detalle tarea clima',
        categoria: 'Cardio',
        experiencia: 15.0,
        creadaEn: DateTime.now(),
        clima: 'Nublado',
      );
      service.agregarTarea(tarea);

      final t = service.tareas.firstWhere((t) => t.id == 'detalleClima');
      expect(t.clima, 'Nublado');
    });

    test('TI-011 y TI-012: Mostrar y listar tareas', () {
      final t1 = Tarea(
        id: 'user1',
        nombre: 'Tarea usuario 1',
        categoria: 'Cardio',
        experiencia: 10.0,
        creadaEn: DateTime.now(),
      );
      final t2 = Tarea(
        id: 'user2',
        nombre: 'Tarea usuario 2',
        categoria: 'Fuerza',
        experiencia: 20.0,
        creadaEn: DateTime.now(),
      );
      service.agregarTarea(t1);
      service.agregarTarea(t2);

      expect(service.tareas.length, greaterThanOrEqualTo(2));
      expect(service.tareas.any((t) => t.id == 'user1'), isTrue);
      expect(service.tareas.any((t) => t.id == 'user2'), isTrue);
    });

    test('TI-013: Registrar hora de creación correcta', () {
      final ahora = DateTime.now();
      final tarea = Tarea(
        id: 'hora1',
        nombre: 'Registrar hora',
        categoria: 'Resistencia',
        experiencia: 5.0,
        creadaEn: ahora,
      );
      service.agregarTarea(tarea);

      final t = service.tareas.firstWhere((t) => t.id == 'hora1');
      expect(t.creadaEn.difference(ahora).inSeconds.abs(), lessThan(2));
    });
  });
}
