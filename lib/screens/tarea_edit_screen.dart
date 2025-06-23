import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tarea.dart';
import '../services/tareas_service.dart';

class TareaEditScreen extends StatefulWidget {
  final Tarea tarea;

  const TareaEditScreen({super.key, required this.tarea});

  @override
  State<TareaEditScreen> createState() => _TareaEditScreenState();
}

class _TareaEditScreenState extends State<TareaEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _experienciaController;
  String? _categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.tarea.nombre);
    _experienciaController =
        TextEditingController(text: widget.tarea.experiencia.toString());
    _categoriaSeleccionada = widget.tarea.categoria;
  }

  @override
  Widget build(BuildContext context) {
    final categorias = Provider.of<TareasService>(context).categorias;

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Tarea')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _experienciaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Experiencia %'),
                validator: (value) =>
                    value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              DropdownButtonFormField<String>(
                value: _categoriaSeleccionada,
                decoration: const InputDecoration(labelText: 'Categoría'),
                items: categorias
                    .map((cat) =>
                        DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _categoriaSeleccionada = val;
                  });
                },
                validator: (value) =>
                    value == null ? 'Selecciona una categoría' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final tareaActualizada = Tarea(
                      id: widget.tarea.id,
                      nombre: _nombreController.text,
                      experiencia:
                          double.tryParse(_experienciaController.text) ?? 0,
                      categoria: _categoriaSeleccionada!,
                      creadaEn: widget.tarea.creadaEn,
                      imagenPath: widget.tarea.imagenPath,
                      completadaEn: widget.tarea.completadaEn,
                      clima: widget.tarea.clima,
                    );

                    Provider.of<TareasService>(context, listen: false)
                        .actualizarTarea(tareaActualizada);

                    Navigator.pop(context);
                  }
                },
                child: const Text('Guardar cambios'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
