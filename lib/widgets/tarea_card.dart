import 'dart:io';
import 'package:flutter/material.dart';
import '../models/tarea.dart';
import 'package:intl/intl.dart';

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
    final completada = tarea.completadaEn != null;
    final fechaFormateada = completada
        ? DateFormat('dd/MM/yyyy - HH:mm').format(tarea.completadaEn!)
        : null;

    return Card(
      child: ListTile(
        leading: tarea.imagenPath != null
            ? Image.file(File(tarea.imagenPath!), width: 40, height: 40, fit: BoxFit.cover)
            : null,
        title: Text(tarea.nombre),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${tarea.categoria} - ${tarea.experiencia}% experiencia'),
            if (completada) ...[
              Text('Completada: $fechaFormateada'),
              if (tarea.clima != null) Text('Clima: ${tarea.clima}', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!completada)
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
      ),
    );
  }
}
