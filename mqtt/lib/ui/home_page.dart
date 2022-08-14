import 'package:flutter/material.dart';
import 'package:mqtt/foundation/app.dart';
import 'package:mqtt/ui/mobile_page.dart';
import 'package:mqtt/ui/windows_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MobilePage();
    if (App.isWindows) return const WindowsPage();
  }
}
