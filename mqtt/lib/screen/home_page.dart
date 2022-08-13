import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Demo'),
      ),
      body: Column(
        children: [
          const Text('Pick your game folder'),
          ElevatedButton(
            onPressed: () async {
              final path = await FilePicker.platform.getDirectoryPath();
              print(path);
            },
            child: const Text('Pick folder'),
          ),
        ],
      ),
    );
  }
}
