import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/tarea.dart';
import '../services/tareas_service.dart';

class TareaFormScreen extends StatefulWidget {
  const TareaFormScreen({super.key});

  @override
  State<TareaFormScreen> createState() => _TareaFormScreenState();
}

class _TareaFormScreenState extends State<TareaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _experienciaController = TextEditingController();
  String? _categoriaSeleccionada;

  @override
  Widget build(BuildContext context) {
    final categorias = Provider.of<TareasService>(context).categorias;

    if (_categoriaSeleccionada == null && categorias.isNotEmpty) {
      _categoriaSeleccionada = categorias.first;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Tarea')),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obligatorio';
                  }
                  final numero = double.tryParse(value);
                  if (numero == null) {
                    return 'Debe ser un número válido';
                  }
                  if (numero <= 0 || numero > 100) {
                    return 'Debe estar entre 1 y 100';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: categorias.contains(_categoriaSeleccionada)
                    ? _categoriaSeleccionada
                    : null,
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
                    final tarea = Tarea(
                      id: const Uuid().v4(),
                      nombre: _nombreController.text,
                      experiencia:
                          double.parse(_experienciaController.text),
                      categoria: _categoriaSeleccionada!,
                      creadaEn: DateTime.now(),
                    );
                    Provider.of<TareasService>(context, listen: false)
                        .agregarTarea(tarea);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Guardar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
