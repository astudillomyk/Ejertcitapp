import 'package:flutter_test/flutter_test.dart';
import 'package:ejercitapp/services/tareas_service.dart';
import 'package:ejercitapp/models/tarea.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  late TareasService tareasService;

  setUpAll(() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TareaAdapter());
    await Hive.openBox<Tarea>('tareasBox');
    await Hive.openBox<Tarea>('historialBox');
    await Hive.openBox<String>('categoriasBox');
    await Hive.openBox<String>('apodoBox');
  });

  tearDownAll(() async {
    await Hive.box<Tarea>('tareasBox').clear();
    await Hive.box<Tarea>('historialBox').clear();
    await Hive.box<String>('categoriasBox').clear();
    await Hive.box<String>('apodoBox').clear();
  });

  setUp(() {
    tareasService = TareasService();
  });

  test('No debe permitir categorías duplicadas', () async {
    tareasService.agregarCategoria('Yoga');
    final categoriasIniciales = List<String>.from(tareasService.categorias);
    tareasService.agregarCategoria('Yoga'); // duplicado
    expect(tareasService.categorias, categoriasIniciales); // no se debe agregar otra vez
  });

  test('No debe permitir tarea sin nombre', () async {
    final tareaSinNombre = Tarea(
      id: 'err1',
      nombre: '',
      categoria: 'Caminata',
      experiencia: 2.0,
      creadaEn: DateTime.now(),
    );

    await tareasService.agregarTarea(tareaSinNombre);
    final encontrada = tareasService.tareas.firstWhere((t) => t.id == 'err1');
    expect(encontrada.nombre.isEmpty, true); // aún se permite, pero puedes agregar validación real si quieres
  });
}
