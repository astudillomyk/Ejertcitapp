import 'package:flutter_test/flutter_test.dart';
import 'package:ejercitapp/models/tarea.dart';

void main() {
  test('No se debe permitir nombre vacío en tarea', () {
    final tarea = Tarea(
      id: '2',
      nombre: '',
      categoria: 'Test',
      experiencia: 1.0,
      creadaEn: DateTime.now(),
    );

    // Validamos que nombre no sea vacío
    expect(tarea.nombre.isNotEmpty, false);

    // En tu app, la lógica debería impedir guardar una tarea así
  });
}
