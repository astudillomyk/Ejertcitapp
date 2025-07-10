// tareas_service.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/tarea.dart';

class TareasService extends ChangeNotifier {
  List<Tarea> _tareas = [];
  List<Tarea> _historialEliminadas = [];
  List<String> _categorias = [];
  String _apodo = '';

  List<Tarea> get tareas => _tareas;
  List<Tarea> get historial => _historialEliminadas;
  List<String> get categorias => _categorias;
  String get apodo => _apodo;

  Future<void> cargarDatos() async {
    final tareasBox = Hive.box<Tarea>('tareasBox');
    final historialBox = Hive.box<Tarea>('historialBox');
    final categoriasBox = Hive.box<String>('categoriasBox');
    final apodoBox = Hive.box<String>('apodoBox');

    _tareas = tareasBox.values.toList();
    _historialEliminadas = historialBox.values.toList();
    _categorias = categoriasBox.values.toList();

    if (_categorias.isEmpty) {
      _categorias = ['Caminata', 'Natación', 'Levantamiento de peso'];
      for (var cat in _categorias) {
        categoriasBox.add(cat);
      }
    }

    _apodo = apodoBox.get('apodo', defaultValue: '')!;
    notifyListeners();
  }

  Future<void> guardarTareas() async {
    final box = Hive.box<Tarea>('tareasBox');
    await box.clear();
    for (var tarea in _tareas) {
      await box.put(tarea.id, tarea);
    }
  }

  Future<void> guardarHistorial() async {
    final box = Hive.box<Tarea>('historialBox');
    await box.clear();
    for (var tarea in _historialEliminadas) {
      await box.put(tarea.id, tarea);
    }
  }

  Future<void> guardarCategorias() async {
    final box = Hive.box<String>('categoriasBox');
    await box.clear();
    for (var cat in _categorias) {
      await box.add(cat);
    }
  }

  Future<void> guardarApodo() async {
    final box = Hive.box<String>('apodoBox');
    await box.put('apodo', _apodo);
  }

  Future<void> agregarTarea(Tarea tarea) async {
    if (_tareas.any((t) => t.id == tarea.id)) return;
    _tareas.add(tarea);
    await guardarTareas();
    notifyListeners();
  }

  void actualizarTarea(Tarea tarea) {
    final index = _tareas.indexWhere((t) => t.id == tarea.id);
    if (index != -1) {
      _tareas[index] = tarea;
      guardarTareas();
      notifyListeners();
    }
  }

  void eliminarTarea(String id) {
    final tarea = _tareas.firstWhere((t) => t.id == id);
    _historialEliminadas.add(tarea);
    _tareas.removeWhere((t) => t.id == id);
    guardarTareas();
    guardarHistorial();
    notifyListeners();
  }

  void completarTarea(String id, String imagenPath, {String? clima}) {
    final index = _tareas.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tareas[index] = _tareas[index].copyWith(
        imagenPath: imagenPath,
        completadaEn: DateTime.now(),
        clima: clima ?? _tareas[index].clima,
      );
      guardarTareas();
      notifyListeners();
    }
  }

  void agregarCategoria(String categoria) {
    if (!_categorias.contains(categoria)) {
      _categorias.add(categoria);
      guardarCategorias();
      notifyListeners();
    }
  }

  void setApodo(String apodo) {
    _apodo = apodo;
    guardarApodo();
    notifyListeners();
  }

  Future<String?> obtenerClimaActual() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      if (permission == LocationPermission.deniedForever) return null;

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      final apiKey = dotenv.env['OPENWEATHER_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) return null;

      final url =
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&units=metric&lang=es&appid=$apiKey';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final climaDescripcion = data['weather'][0]['description'];
        final temperatura = data['main']['temp'].toString();
        return '$climaDescripcion, $temperatura°C';
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
