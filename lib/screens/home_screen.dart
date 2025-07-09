import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../services/tareas_service.dart';
import '../widgets/tarea_card.dart';
import 'tarea_form_screen.dart';
import 'categoria_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tareasService = Provider.of<TareasService>(context);
    final tareas = tareasService.tareas;

    final tareasInconclusas = tareas.where((t) => t.completadaEn == null).toList();
    final tareasCompletadas = tareas.where((t) => t.completadaEn != null).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora de Ejercicio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/historial');
            },
          ),
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CategoriaFormScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/perfil');
            },
          ),
        ],
      ),
      body: tareas.isEmpty
          ? const Center(child: Text('No hay tareas registradas.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tareas Inconclusas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...tareasInconclusas.map((tarea) => TareaCard(
                        tarea: tarea,
                        onEliminar: () => tareasService.eliminarTarea(tarea.id),
                        onCompletar: () async {
                          final picker = ImagePicker();
                          final image = await picker.pickImage(source: ImageSource.camera);
                          if (image != null) {
                            // Obtener clima desde el servicio
                            final clima = await tareasService.obtenerClimaActual();
                            tareasService.completarTarea(tarea.id, image.path, clima: clima);
                          }
                        },
                      )),
                  const SizedBox(height: 16),
                  const Text(
                    'Tareas Completadas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...tareasCompletadas.map((tarea) => TareaCard(
                        tarea: tarea,
                        onEliminar: () => tareasService.eliminarTarea(tarea.id),
                        onCompletar: () {}, // Ya completada
                      )),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TareaFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
