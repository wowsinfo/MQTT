import 'package:flutter/material.dart';
import 'package:mqtt/ui/qr_scanner_page.dart';

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
        title: Text('Mobile'),
      ),
      body: Center(
        child: TextButton.icon(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const QRScannerPage(),
              ),
            );
          },
          icon: const Icon(Icons.qr_code),
          label: const Text('Scan QR'),
        ),
      ),
    );
  }
}
