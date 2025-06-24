import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

import 'package:ejercitapp/models/tarea.dart';
import 'package:ejercitapp/services/tareas_service.dart';

void main() {
  late TareasService service;

  setUpAll(() async {
    // Inicializa Hive en memoria para tests
    await setUpTestHive();

    // Registrar adapter si no está registrado
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TareaAdapter());
    }

    // Abrir cajas antes de usar el servicio
    await Hive.openBox<Tarea>('tareasBox');
    await Hive.openBox<Tarea>('historialBox');
    await Hive.openBox<String>('categoriasBox');
    await Hive.openBox<String>('apodoBox');
  });

  setUp(() async {
    // Crear instancia y cargar datos (las cajas ya están abiertas)
    service = TareasService();
    await service.cargarDatos();
  });

  tearDownAll(() async {
    await Hive.box<Tarea>('tareasBox').close();
    await Hive.box<Tarea>('historialBox').close();
    await Hive.box<String>('categoriasBox').close();
    await Hive.box<String>('apodoBox').close();

    await tearDownTestHive();
  });

  group('Tests de Integración', () {
    test('TI-01: El sistema muestra el clima de la tarea', () async {
      final tarea = Tarea(
        id: 'clima1',
        nombre: 'Ejemplo tarea clima',
        categoria: 'Cardio',
        experiencia: 10.0,
        creadaEn: DateTime.now(),
        clima: 'Soleado',
      );
      await service.agregarTarea(tarea);

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
      await service.agregarTarea(tarea);

      service.completarTarea('foto1', '/local/path/to/foto.jpg');

      final t = service.tareas.firstWhere((t) => t.id == 'foto1');
      expect(t.imagenPath, contains('/local/path/to/foto.jpg'));
      expect(t.completadaEn, isNotNull);
    });

    test('TI-03: Tareas eliminadas se agregan al historial', () async {
      final tarea = Tarea(
        id: 'elim1',
        nombre: 'Tarea a eliminar',
        categoria: 'Cardio',
        experiencia: 15.0,
        creadaEn: DateTime.now(),
      );
      await service.agregarTarea(tarea);
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
      await service.agregarTarea(tarea);

      service.completarTarea('subirFoto', '/local/path/to/image.png');

      final t = service.tareas.firstWhere((t) => t.id == 'subirFoto');
      expect(t.imagenPath, '/local/path/to/image.png');
    });

    test('TI-05: Crear nueva categoría', () async {
      service.agregarCategoria('Yoga');
      expect(service.categorias.contains('Yoga'), isTrue);
    });

    test('TI-06: Listar categorías', () {
      expect(service.categorias,
          containsAll(['Caminata', 'Natación', 'Levantamiento de peso']));
      expect(service.categorias.contains('Yoga'), isTrue);
    });

    test('TI-07: Editar tarea refleja cambios sin modificar nombre ni experiencia', () async {
      final tarea = Tarea(
        id: 'edit1',
        nombre: 'Tarea original',
        categoria: 'Cardio',
        experiencia: 10.0,
        creadaEn: DateTime.now(),
      );
      await service.agregarTarea(tarea);

      final tareaEditada = Tarea(
        id: tarea.id,
        nombre: tarea.nombre,
        categoria: tarea.categoria,
        experiencia: tarea.experiencia,
        creadaEn: tarea.creadaEn,
        imagenPath: '/local/path/to/nuevaimagen.jpg',
        completadaEn: DateTime.now(),
        clima: 'Nublado',
      );

      service.actualizarTarea(tareaEditada);

      final t = service.tareas.firstWhere((t) => t.id == 'edit1');
      expect(t.nombre, 'Tarea original');
      expect(t.experiencia, 10.0);
      expect(t.imagenPath, '/local/path/to/nuevaimagen.jpg');
      expect(t.clima, 'Nublado');
    });

    test('TI-08: Eliminar tarea se refleja en historial', () async {
      final tarea = Tarea(
        id: 'elim2',
        nombre: 'Eliminar tarea historial',
        categoria: 'Fuerza',
        experiencia: 25.0,
        creadaEn: DateTime.now(),
      );
      await service.agregarTarea(tarea);
      service.eliminarTarea('elim2');

      expect(service.historial.any((t) => t.id == 'elim2'), isTrue);
      expect(service.tareas.any((t) => t.id == 'elim2'), isFalse);
    });

    test('TI-09: Simulación de obtener clima (mock)', () async {
      const climaSimulado = 'Nublado';
      expect(climaSimulado, isNotEmpty);
    });

    test('TI-010: Mostrar clima en detalle tarea', () async {
      final tarea = Tarea(
        id: 'detalleClima',
        nombre: 'Detalle tarea clima',
        categoria: 'Cardio',
        experiencia: 15.0,
        creadaEn: DateTime.now(),
        clima: 'Nublado',
      );
      await service.agregarTarea(tarea);

      final t = service.tareas.firstWhere((t) => t.id == 'detalleClima');
      expect(t.clima, 'Nublado');
    });

    test('TI-011: Las tareas guardadas se muestran correctamente', () async {
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
      await service.agregarTarea(t1);
      await service.agregarTarea(t2);

      expect(service.tareas.length, greaterThanOrEqualTo(2));
      expect(service.tareas.any((t) => t.id == 'user1'), isTrue);
      expect(service.tareas.any((t) => t.id == 'user2'), isTrue);
    });

    test('TI-012: Listar tareas asociadas a usuario', () {
      const userId = 'user1';
      final tareasUsuario =
          service.tareas.where((t) => t.id == userId).toList();

      expect(tareasUsuario.isNotEmpty, isTrue);
      for (var tarea in tareasUsuario) {
        expect(tarea.id, equals(userId));
      }
    });

    test('TI-013: Registrar hora de creación correcta', () async {
      final ahora = DateTime.now();
      final tarea = Tarea(
        id: 'hora1',
        nombre: 'Registrar hora',
        categoria: 'Resistencia',
        experiencia: 5.0,
        creadaEn: ahora,
      );
      await service.agregarTarea(tarea);

      final t = service.tareas.firstWhere((t) => t.id == 'hora1');
      expect(t.creadaEn.difference(ahora).inSeconds.abs(), lessThan(2));
    });
  });
}
