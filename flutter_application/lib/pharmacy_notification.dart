import 'package:flutter/material.dart';
import 'package:flutter_application/constant/colors.dart';

class PharmacyNotificationPage extends StatelessWidget {
  final List<String> notifications = [
    '새로운 처방전이 등록되었습니다.',
    '약국 운영시간 변경 안내.',
    '약 복용을 완료하셨나요?',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림',style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),),
        backgroundColor: AppColors.primary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('알림 ${index + 1} 클릭됨')),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.notifications, color: AppColors.primary),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        notifications[index],
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                    // const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}