import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mqtt/foundation/app.dart';

class QRScannerPage extends StatelessWidget {
  const QRScannerPage({Key? key, this.onQRCodeScanned}) : super(key: key);

  final void Function(String)? onQRCodeScanned;

  @override
  Widget build(BuildContext context) {
    if (App.isMobile) {
      return Scaffold(
        appBar: AppBar(title: const Text('QR Scanner')),
        body: MobileScanner(
          allowDuplicates: false,
          controller: MobileScannerController(),
          onDetect: (barcode, args) {
            if (barcode.rawValue == null) {
              debugPrint('Failed to scan Barcode');
            } else {
              final String code = barcode.rawValue!;
              onQRCodeScanned?.call(code);
              Navigator.of(context).pop();
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
