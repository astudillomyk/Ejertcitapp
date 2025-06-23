import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/tareas_service.dart';

Future<void> completarTareaConImagen(BuildContext context, String tareaId) async {
  final picker = ImagePicker();
  final image = await picker.pickImage(source: ImageSource.camera);
  if (image != null) {
    Provider.of<TareasService>(context, listen: false)
        .completarTarea(tareaId, image.path);
  }
}
