import 'package:flutter_test/flutter_test.dart';
import 'package:ejercitapp/models/tarea.dart';

void main() {
  group('Tarea model tests', () {
    test('El constructor inicializa los campos correctamente', () {
      final fechaCreacion = DateTime.now();
      final fechaCompletada = DateTime.now();

      final tarea = Tarea(
        id: 'test1',
        nombre: 'Ejemplo tarea',
        categoria: 'Cardio',
        experiencia: 10.5,
        creadaEn: fechaCreacion,
        imagenPath: 'https://imagen',
        completadaEn: fechaCompletada,
        clima: 'Soleado',
      );

      expect(tarea.id, 'test1');
      expect(tarea.nombre, 'Ejemplo tarea');
      expect(tarea.categoria, 'Cardio');
      expect(tarea.experiencia, 10.5);
      expect(tarea.creadaEn, fechaCreacion);
      expect(tarea.imagenPath, 'https://imagen');
      expect(tarea.completadaEn, fechaCompletada);
      expect(tarea.clima, 'Soleado');
    });

    test('copyWith actualiza solo campos indicados', () {
      final fechaCreacion = DateTime.now();
      final tareaOriginal = Tarea(
        id: 'test2',
        nombre: 'Original',
        categoria: 'Fuerza',
        experiencia: 20.0,
        creadaEn: fechaCreacion,
      );

      const nuevaImagen = 'https://imagen';
      final fechaCompletada = DateTime.now();
      const nuevoClima = 'Nublado';

      final tareaModificada = tareaOriginal.copyWith(
        imagenPath: nuevaImagen,
        completadaEn: fechaCompletada,
        clima: nuevoClima,
      );

      expect(tareaModificada.id, tareaOriginal.id);
      expect(tareaModificada.nombre, tareaOriginal.nombre);
      expect(tareaModificada.categoria, tareaOriginal.categoria);
      expect(tareaModificada.experiencia, tareaOriginal.experiencia);
      expect(tareaModificada.creadaEn, tareaOriginal.creadaEn);

      expect(tareaModificada.imagenPath, nuevaImagen);
      expect(tareaModificada.completadaEn, fechaCompletada);
      expect(tareaModificada.clima, nuevoClima);
    });

    test('copyWith sin parámetros devuelve igual que original', () {
      final fechaCreacion = DateTime.now();
      final tareaOriginal = Tarea(
        id: 'test3',
        nombre: 'Tarea',
        categoria: 'Natación',
        experiencia: 15.0,
        creadaEn: fechaCreacion,
        imagenPath: null,
        completadaEn: null,
        clima: null,
      );

      final copia = tareaOriginal.copyWith();

      expect(copia.id, tareaOriginal.id);
      expect(copia.nombre, tareaOriginal.nombre);
      expect(copia.categoria, tareaOriginal.categoria);
      expect(copia.experiencia, tareaOriginal.experiencia);
      expect(copia.creadaEn, tareaOriginal.creadaEn);

      expect(copia.imagenPath, isNull);
      expect(copia.completadaEn, isNull);
      expect(copia.clima, isNull);
    });

    test('Crea una tarea solo con los campos requeridos', () {
      final now = DateTime.now();
      final tarea = Tarea(
        id: 'basic1',
        nombre: 'Flexiones',
        categoria: 'Fuerza',
        experiencia: 15.0,
        creadaEn: now,
      );

      expect(tarea.id, 'basic1');
      expect(tarea.imagenPath, isNull);
      expect(tarea.completadaEn, isNull);
      expect(tarea.clima, isNull);
    });

    test('copyWith conserva los campos no modificados', () {
      final now = DateTime.now();
      final tarea = Tarea(
        id: 'keep',
        nombre: 'Saltar la cuerda',
        categoria: 'Cardio',
        experiencia: 8.0,
        creadaEn: now,
      );

      final copia = tarea.copyWith();

      expect(copia.id, tarea.id);
      expect(copia.nombre, tarea.nombre);
      expect(copia.categoria, tarea.categoria);
      expect(copia.experiencia, tarea.experiencia);
      expect(copia.creadaEn, tarea.creadaEn);
    });

    test('Dos tareas con mismo ID pero distintas propiedades no son iguales', () {
      final now = DateTime.now();
      final t1 = Tarea(
        id: 'abc',
        nombre: 'Correr',
        categoria: 'Cardio',
        experiencia: 10,
        creadaEn: now,
      );

      final t2 = Tarea(
        id: 'abc',
        nombre: 'Ciclismo',
        categoria: 'Cardio',
        experiencia: 20,
        creadaEn: now,
      );

      expect(t1 == t2, isFalse);
    });

    test('Tarea puede tener experiencia 0', () {
      final now = DateTime.now();
      final t = Tarea(
        id: 'zeroXp',
        nombre: 'Respirar',
        categoria: 'Descanso',
        experiencia: 0.0,
        creadaEn: now,
      );

      expect(t.experiencia, 0.0);
    });
  });
}
