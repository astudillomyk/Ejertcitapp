import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

import 'package:ejercitapp/models/tarea.dart';
import 'package:ejercitapp/services/tareas_service.dart';

void main() {
  late TareasService service;

  setUp(() async {
    await setUpTestHive();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TareaAdapter());
    }

    await Hive.openBox<Tarea>('tareasBox');
    await Hive.openBox<Tarea>('historialBox');
    await Hive.openBox<String>('categoriasBox');
    await Hive.openBox<String>('apodoBox');

    service = TareasService();
    await service.cargarDatos();
  });

  tearDown(() async {
    // Wait a moment to let background Hive writes complete
    await Future.delayed(const Duration(milliseconds: 50));
    await tearDownTestHive();
  });

  test('ST-01: Agregar tarea con nombre, experiencia y categoría', () {
    final tarea = Tarea(
      id: '1',
      nombre: 'Saltar cuerda',
      categoria: 'Cardio',
      experiencia: 15.0,
      creadaEn: DateTime.now(),
    );

    service.agregarTarea(tarea);

    expect(service.tareas.length, 1);
    expect(service.tareas.first.nombre, 'Saltar cuerda');
    expect(service.tareas.first.experiencia, 15.0);
  });

  test('ST-02: Completar tarea con imagen asignada', () {
    final tarea = Tarea(
      id: '2',
      nombre: 'Bicicleta',
      categoria: 'Cardio',
      experiencia: 20,
      creadaEn: DateTime.now(),
    );

    service.agregarTarea(tarea);

    service.completarTarea('2', '/path/to/imagen.jpg', clima: 'Soleado');

    final actualizada = service.tareas.firstWhere((t) => t.id == '2');
    expect(actualizada.imagenPath, '/path/to/imagen.jpg');
    expect(actualizada.clima, 'Soleado');
    expect(actualizada.completadaEn, isNotNull);
  });

  test('ST-03: Eliminar tarea la mueve al historial', () {
    final tarea = Tarea(
      id: '4',
      nombre: 'Remo',
      categoria: 'Fuerza',
      experiencia: 25.0,
      creadaEn: DateTime.now(),
    );

    service.agregarTarea(tarea);
    service.eliminarTarea('4');

    expect(service.tareas, isEmpty);
    expect(service.historial.length, 1);
    expect(service.historial.first.nombre, 'Remo');
  });

  test('ST-05: Registrar hora creación y finalización en tarea', () {
    final now = DateTime.now();
    final tarea = Tarea(
      id: '5',
      nombre: 'Spinning',
      categoria: 'Cardio',
      experiencia: 12,
      creadaEn: now,
    );

    service.agregarTarea(tarea);
    service.completarTarea('5', '/img.jpg');

    final t = service.tareas.first;
    expect(t.creadaEn, isNotNull);
    expect(t.completadaEn, isNotNull);
  });




}
