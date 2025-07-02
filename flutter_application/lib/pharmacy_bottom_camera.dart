import 'package:flutter/material.dart';
import 'package:flutter_application/constant/colors.dart';
import 'package:flutter_application/pharmacy_ocr_camera.dart';
import 'package:flutter_application/pharmacy_qr_camera.dart';

class PharmacyQRCameraPage extends StatelessWidget {
  const PharmacyQRCameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('기능 선택', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),),backgroundColor: AppColors.primary,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code,color: AppColors.primary,),
              label: const Text('QR 인식',style: TextStyle(color: Colors.black,fontSize: 17),),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const QRScanner(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt, color: AppColors.primary,),
              label: const Text('OCR 촬영',style: TextStyle(color: Colors.black, fontSize: 17),),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PharmacyOCRCameraPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}