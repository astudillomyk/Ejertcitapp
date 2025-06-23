import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tareas_service.dart';
import '../widgets/tarea_card.dart';
import 'tarea_form_screen.dart';
import 'categoria_form_screen.dart'; // Asegúrate de importar la pantalla de categorías
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tareasService = Provider.of<TareasService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitácora de Ejercicio'),
        actions: [
          // Icono para ver historial
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/historial');
            },
          ),
          // Icono para crear nuevas categorías
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CategoriaFormScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: tareasService.tareas.map<Widget>((tarea) {
          return TareaCard(
            tarea: tarea,
            onEliminar: () => tareasService.eliminarTarea(tarea.id),
            onCompletar: () async {
              final picker = ImagePicker();
              final image =
                  await picker.pickImage(source: ImageSource.camera);
              if (image != null) {
                tareasService.completarTarea(tarea.id, image.path);
              }
            },
          );
        }).toList(),
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
