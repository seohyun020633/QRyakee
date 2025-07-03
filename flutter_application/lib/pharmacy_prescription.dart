import 'package:flutter/material.dart';
import 'package:flutter_application/constant/colors.dart';

class PharmacyPrescriptionPage extends StatelessWidget {
  final String patientName;
  final String rrn;
  final String date;
  final String number;

  const PharmacyPrescriptionPage({
    super.key,
    required this.patientName,
    required this.rrn,
    required this.date,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("처방전 상세", style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold)),
      backgroundColor: AppColors.primary,),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('환자 이름: $patientName', style: const TextStyle(fontSize: 17)),
            const SizedBox(height: 10),
            Text('주민등록번호: $rrn', style: const TextStyle(fontSize: 17)),
            const SizedBox(height: 10),
            Text('교부 일자: $date', style: const TextStyle(fontSize: 17)),
            const SizedBox(height: 10),
            Text('교부 번호: $number', style: const TextStyle(fontSize: 17)),
          ],
        ),
      ),
    );
  }
}