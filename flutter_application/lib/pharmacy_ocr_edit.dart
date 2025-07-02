import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application/constant/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:flutter_application/pharmacy_bottom_nav.dart';

class PharmacyOCREditPage extends StatefulWidget {
  final File image;
  final String recognizedText;

  const PharmacyOCREditPage({
    super.key,
    required this.image,
    required this.recognizedText,
  });

  @override
  State<PharmacyOCREditPage> createState() => _PharmacyOCREditPageState();
}

class _PharmacyOCREditPageState extends State<PharmacyOCREditPage> {
  late TextEditingController _patientNameController;
  late TextEditingController _prescriptionNumberController;
  late TextEditingController _dateController;
  late TextEditingController _pharmacyController;
  late TextEditingController _medicineController;
  late TextEditingController _dosePerTimeController;
  late TextEditingController _dosePerDayController;
  late TextEditingController _totalDaysController;

  @override
  void initState() {
    super.initState();

    //초기화
    _patientNameController = TextEditingController();
    _prescriptionNumberController = TextEditingController();
    _dateController = TextEditingController();
    _pharmacyController = TextEditingController();
    _medicineController = TextEditingController();
    _dosePerTimeController = TextEditingController();
    _dosePerDayController = TextEditingController();
    _totalDaysController = TextEditingController();

    // 임시
    _medicineController.text = widget.recognizedText;
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _prescriptionNumberController.dispose();
    _dateController.dispose();
    _pharmacyController.dispose();
    _medicineController.dispose();
    _dosePerTimeController.dispose();
    _dosePerDayController.dispose();
    _totalDaysController.dispose();
    super.dispose();
  }

  Future<void> _saveImageAndText(BuildContext context) async {
    final directory = await getExternalStorageDirectory();
    final imageName = basename(widget.image.path);
    final savedImage = await widget.image.copy('${directory!.path}/$imageName');

    // 저장 완료 알림
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('저장 완료: ${savedImage.path}')),
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => PharmacyBottomNav()),
      (route) => false,
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OCR 결과 확인', style:TextStyle(fontSize: 21,fontWeight: FontWeight.bold),),backgroundColor: AppColors.primary,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(widget.image, height: 200),
            const SizedBox(height: 16),
            _buildField('환자명', _patientNameController),
            _buildField('교부번호', _prescriptionNumberController),
            _buildField('교부일자', _dateController),
            _buildField('약국명', _pharmacyController),
            _buildField('약품명', _medicineController),
            _buildField('1회 복용량', _dosePerTimeController),
            _buildField('1일 복용횟수', _dosePerDayController),
            _buildField('총 복용일수', _totalDaysController),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => _saveImageAndText(context),
                child: const Text('저장하기',style:TextStyle(fontSize: 15,color: Colors.black),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}