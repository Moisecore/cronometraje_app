import 'package:flutter/material.dart';
import 'package:cronometraje_app/viewmodels/chrono_viewmodel.dart';
import 'package:provider/provider.dart';

class CreateChronoView extends StatefulWidget {
  const CreateChronoView({super.key});

  @override
  CreateChronoViewState createState() => CreateChronoViewState();
}

class CreateChronoViewState extends State<CreateChronoView> {
  final TextEditingController _nameController = TextEditingController();

  void _createChrono(BuildContext context) async {
    final chronoViewModel = Provider.of<ChronoViewModel>(context, listen: false);
    final name = _nameController.text.trim();

    if (name.isNotEmpty) {
      await chronoViewModel.addChrono(name);
      _showDialog(context, true, name);
    } else {
      _showDialog(context, false, name);
    }
  }

  void _showDialog(BuildContext context, bool success, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(success ? 'Chrono Creado' : 'Error'),
        content: Text(success
            ? 'Chrono "$name" creado exitosamente.'
            : 'Error: Nombre del Chrono no puede estar vacío.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (success) {
                Navigator.of(context).pop();
              }
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Chrono'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        leading: const Icon(Icons.timer),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Nombre del Chrono'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _createChrono(context),
                  child: Text('Crear'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}