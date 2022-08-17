import 'package:flutter/material.dart';
import 'package:mqtt/localisation/localisation.dart';
import 'package:mqtt/ui/game_info_page.dart';

class MobilePage extends StatefulWidget {
  const MobilePage({Key? key}) : super(key: key);

  @override
  State<MobilePage> createState() => _MobilePageState();
}

class _MobilePageState extends State<MobilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Localisation.of(context).app_title),
      ),
      body: const GameInfoPage(),
    );
  }
}
