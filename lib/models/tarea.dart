import 'package:hive/hive.dart';

part 'tarea.g.dart';  // Archivo generado por build_runner

@HiveType(typeId: 0)
class Tarea extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String nombre;

  @HiveField(2)
  final String categoria;

  @HiveField(3)
  final double experiencia;

  @HiveField(4)
  final String? imagenPath;

  @HiveField(5)
  final DateTime? completadaEn;

  @HiveField(6)
  final DateTime creadaEn;

  @HiveField(7)
  final String? clima;

  Tarea({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.experiencia,
    this.imagenPath,
    this.completadaEn,
    required this.creadaEn,
    this.clima,
  });

  Tarea copyWith({
    String? imagenPath,
    DateTime? completadaEn,
    String? clima,
  }) {
    return Tarea(
      id: id,
      nombre: nombre,
      categoria: categoria,
      experiencia: experiencia,
      imagenPath: imagenPath ?? this.imagenPath,
      completadaEn: completadaEn ?? this.completadaEn,
      creadaEn: creadaEn,
      clima: clima ?? this.clima,
    );
  }
}
