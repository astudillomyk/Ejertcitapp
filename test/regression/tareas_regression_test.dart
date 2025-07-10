import 'package:flutter_test/flutter_test.dart';
import 'package:ejercitapp/models/tarea.dart';
import 'package:ejercitapp/services/tareas_service.dart';

void main() {
  late TareasService tareasService;

  setUp(() {
    tareasService = TareasService();
  });

  test('Agregar tarea y verificar listado', () async {
    final tarea = Tarea(
      id: '1',
      nombre: 'Test tarea',
      categoria: 'Test categoria',
      experiencia: 3.0,
      creadaEn: DateTime.now(),
    );

    await tareasService.agregarTarea(tarea);

    expect(tareasService.tareas.length, 1);
    expect(tareasService.tareas.first.nombre, 'Test tarea');
  });
}
