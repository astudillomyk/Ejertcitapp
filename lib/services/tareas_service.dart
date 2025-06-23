import 'package:flutter/material.dart';
import '../models/tarea.dart';

class TareasService extends ChangeNotifier {
  final List<Tarea> _tareas = [];
  final List<Tarea> _historialEliminadas = [];

  final List<String> _categorias = [
    'Caminata',
    'Natación',
    'Levantamiento de peso',
  ]; // ✅ Categorías por defecto

  List<Tarea> get tareas => _tareas;
  List<Tarea> get historial => _historialEliminadas;
  List<String> get categorias => _categorias;

  void agregarTarea(Tarea tarea) {
    _tareas.add(tarea);
    notifyListeners();
  }

  void actualizarTarea(Tarea tarea) {
    final index = _tareas.indexWhere((t) => t.id == tarea.id);
    if (index != -1) {
      _tareas[index] = tarea;
      notifyListeners();
    }
  }

  void eliminarTarea(String id) {
    final tarea = _tareas.firstWhere((t) => t.id == id);
    _historialEliminadas.add(tarea);
    _tareas.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void completarTarea(String id, String imagenPath) {
    final index = _tareas.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tareas[index] = _tareas[index].copyWith(
        imagenPath: imagenPath,
        completadaEn: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void agregarCategoria(String categoria) {
    if (!_categorias.contains(categoria)) {
      _categorias.add(categoria);
      notifyListeners();
    }
  }
}
