// lib/pharmacy_home.dart
import 'package:flutter/material.dart';
import 'package:flutter_application/constant/colors.dart';

class PharmacyHome extends StatelessWidget {
  final List<Map<String, String>> prescriptions = [
    {
      "patientName": "홍길동",
      "rrn": "9001011",
      "date": "2025-06-30",
      "number": "A123456"
    },
    {
      "patientName": "김민지",
      "rrn": "9802022",
      "date": "2025-06-29",
      "number": "B234567"
    },
    {
      "patientName": "이철수",
      "rrn": "0101013",
      "date": "2025-06-28",
      "number": "C345678"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("홈화면"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '건강약국',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: prescriptions.length,
                itemBuilder: (context, index) {
                  final item = prescriptions[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text('환자이름: ${item["patientName"]}')),
                              Text('주민번호: ${item["rrn"]}'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(child: Text('교부일자: ${item["date"]}')),
                              Text('교부번호: ${item["number"]}'),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: 처방전 확인 로직
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), 
                                  side: const BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: const Text('처방전 확인하기'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}