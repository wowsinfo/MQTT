import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mqtt/foundation/app.dart';
import 'package:mqtt/localisation/localisation.dart';

class QRScannerPage extends StatelessWidget {
  const QRScannerPage({Key? key, required this.onQRCodeScanned})
      : super(key: key);

  final void Function(String) onQRCodeScanned;

  @override
  Widget build(BuildContext context) {
    if (App.isMobile) {
      return Scaffold(
        appBar: AppBar(title: Text(Localisation.of(context).qr_code_scanner)),
        body: MobileScanner(
          allowDuplicates: false,
          controller: MobileScannerController(),
          onDetect: (barcode, args) {
            if (barcode.rawValue == null) {
              debugPrint('Failed to scan Barcode');
            } else {
              final String code = barcode.rawValue!;
              onQRCodeScanned(code);
            }
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(Localisation.of(context).qr_code_scanner)),
      body: Center(
        child: Text(Localisation.of(context).error_not_supported),
      ),
    );
  }
}
