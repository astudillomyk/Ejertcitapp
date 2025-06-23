class Tarea {
  final String id;
  final String nombre;
  final String categoria;
  final double experiencia;
  final String? imagenPath;
  final DateTime? completadaEn;

  Tarea({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.experiencia,
    this.imagenPath,
    this.completadaEn,
  });

  Tarea copyWith({
    String? imagenPath,
    DateTime? completadaEn,
  }) {
    return Tarea(
      id: id,
      nombre: nombre,
      categoria: categoria,
      experiencia: experiencia,
      imagenPath: imagenPath ?? this.imagenPath,
      completadaEn: completadaEn ?? this.completadaEn,
    );
  }
}
