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

  test('REG-01: Agregar tarea con nombre y experiencia', () {
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

  test('REG-02: Crear nueva categoría y verificar categorías predeterminadas',
      () {
    // Categorías predeterminadas
    expect(service.categorias,
        containsAll(['Caminata', 'Natación', 'Levantamiento de peso']));

    // Agregar nueva categoría
    service.agregarCategoria('Yoga');
    expect(service.categorias.contains('Yoga'), true);
  });

  test('REG-03: Completar tarea con imagen asignada', () {
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

  test('REG-04: Editar tarea actualiza datos', () {
    final tarea = Tarea(
      id: '3',
      nombre: 'Correr',
      categoria: 'Cardio',
      experiencia: 10.0,
      creadaEn: DateTime.now(),
    );

    service.agregarTarea(tarea);

    final tareaEditada = tarea.copyWith(clima: 'Nublado');
    service.actualizarTarea(tareaEditada);

    final actual = service.tareas.first;
    expect(actual.clima, 'Nublado');
  });

  test('REG-04: Eliminar tarea la mueve al historial', () {
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

  test('REG-05: Ingresar apodo sin autenticación', () {
    service.setApodo('Alfredo');
    expect(service.apodo, 'Alfredo');
  });

  test('REG-07: Registrar hora creación y finalización en tarea', () {
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

  test('REG-08: No se agrega una tarea duplicada con mismo ID', () async {
    final tarea = Tarea(
      id: 'duplicada',
      nombre: 'Ciclismo',
      categoria: 'Cardio',
      experiencia: 10.0,
      creadaEn: DateTime.now(),
    );

    service.agregarTarea(tarea);
    service.agregarTarea(tarea);

    expect(service.tareas.length, 1);
  });

  test('REG-09: No se agrega una categoría duplicada', () async {
    service.agregarCategoria('Yoga');
    final lengthBefore = service.categorias.length;

    service.agregarCategoria('Yoga');
    final lengthAfter = service.categorias.length;

    expect(lengthAfter, equals(lengthBefore));
  });
}
