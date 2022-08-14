import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mqtt/foundation/app.dart';

class QRScannerPage extends StatelessWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (App.isMobile) {
      return Scaffold(
        appBar: AppBar(title: const Text('QR Scanner')),
        body: MobileScanner(
          allowDuplicates: false,
          controller: MobileScannerController(
            facing: CameraFacing.front,
          ),
          onDetect: (barcode, args) {
            if (barcode.rawValue == null) {
              debugPrint('Failed to scan Barcode');
            } else {
              final String code = barcode.rawValue!;
              debugPrint('Barcode found! $code');
            }
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('QR Scanner')),
      body: const Center(
        child: Text('This is not supported on desktop.'),
      ),
    );
  }
}
