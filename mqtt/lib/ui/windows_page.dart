import 'package:flutter/material.dart';
import 'package:mqtt/provider/windows_provider.dart';
import 'package:provider/provider.dart';

class WindowsPage extends StatefulWidget {
  const WindowsPage({Key? key}) : super(key: key);

  @override
  State<WindowsPage> createState() => _WindowsPageState();
}

class _WindowsPageState extends State<WindowsPage> {
  final _provider = WindowsProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MQTT Demo'),
        ),
        body: renderContent(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _provider.showSettings(context),
          child: const Icon(Icons.settings),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget renderContent() {
    if (!_provider.hasValidPath) {
      return const Center(
        child: Text('Please select a valid path'),
      );
    }

    if (!_provider.hasValidServer) {
      return const Center(
        child: Text('Please select a server'),
      );
    }

    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
