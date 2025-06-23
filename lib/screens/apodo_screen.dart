import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tareas_service.dart';

class ApodoScreen extends StatefulWidget {
  const ApodoScreen({super.key});

  @override
  State<ApodoScreen> createState() => _ApodoScreenState();
}

class _ApodoScreenState extends State<ApodoScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final apodo = Provider.of<TareasService>(context, listen: false).apodo;
    _controller.text = apodo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ingresa tu Apodo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Apodo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.trim().isNotEmpty) {
                  Provider.of<TareasService>(context, listen: false)
                      .setApodo(_controller.text.trim());
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              child: const Text('Guardar y continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
