import 'package:flutter/material.dart';
import 'package:flutter_application/constant/colors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends StatelessWidget {
  const QRScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QR 인식',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: AppColors.primary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: MobileScanner(
        controller: MobileScannerController(),
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;
            if (code != null) {
              Navigator.pop(context, code);
            }
          }
        },
      ),
    );
  }
}
