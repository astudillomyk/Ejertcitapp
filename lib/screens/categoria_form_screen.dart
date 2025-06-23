import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tareas_service.dart';

class CategoriaFormScreen extends StatefulWidget {
  const CategoriaFormScreen({super.key});

  @override
  _CategoriaFormScreenState createState() => _CategoriaFormScreenState();
}

class _CategoriaFormScreenState extends State<CategoriaFormScreen> {
  final TextEditingController _nombreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Categoría')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) => value!.isEmpty ? 'Campo obligatorio' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_nombreController.text.isNotEmpty) {
                  Provider.of<TareasService>(context, listen: false)
                      .agregarCategoria(_nombreController.text);
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            )
          ],
        ),
      ),
    );
  }
}
