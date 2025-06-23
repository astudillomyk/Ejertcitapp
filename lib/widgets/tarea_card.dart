import 'dart:io';
import 'package:flutter/material.dart';
import '../models/tarea.dart';

class TareaCard extends StatelessWidget {
  final Tarea tarea;
  final VoidCallback onEliminar;
  final VoidCallback onCompletar;

  const TareaCard({
    super.key,
    required this.tarea,
    required this.onEliminar,
    required this.onCompletar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(tarea.nombre),
        subtitle: Text(
          '${tarea.categoria} - ${tarea.experiencia}% experiencia',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tarea.imagenPath == null)
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: onCompletar,
              )
            else
              const Icon(Icons.check_circle, color: Colors.green),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onEliminar,
            ),
          ],
        ),
        leading: tarea.imagenPath != null
            ? Image.file(File(tarea.imagenPath!), width: 40, height: 40)
            : null,
      ),
    );
  }
}
