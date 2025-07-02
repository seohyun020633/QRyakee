import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'pharmacy_ocr_edit.dart';

class PharmacyOCRCameraPage extends StatefulWidget {
  const PharmacyOCRCameraPage({super.key});

  @override
  State<PharmacyOCRCameraPage> createState() => _PharmacyOCRCameraPageState();
}

class _PharmacyOCRCameraPageState extends State<PharmacyOCRCameraPage> {
  Future<void> _captureAndRecognizeText() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked == null) return;

    final imageFile = File(picked.path);
    final inputImage = InputImage.fromFilePath(imageFile.path);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PharmacyOCREditPage(
          image: imageFile,
          recognizedText: recognizedText.text,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _captureAndRecognizeText();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}