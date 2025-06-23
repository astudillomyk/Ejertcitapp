import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tareas_service.dart';

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historial = Provider.of<TareasService>(context).historial;

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Eliminaciones')),
      body: ListView.builder(
        itemCount: historial.length,
        itemBuilder: (context, index) {
          final tarea = historial[index];
          return ListTile(
            title: Text(tarea.nombre),
            subtitle: Text('Eliminada: ${tarea.categoria} - ${tarea.experiencia}%'),
          );
        },
      ),
    );
  }
}
