import 'package:flutter/material.dart';
import '../constant/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PDFsaveScreen(),
    );
  }
}

class PDFsaveScreen extends StatelessWidget {
  const PDFsaveScreen({super.key});

  void _showSaveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PDF 저장'),
        content: const Text('PDF 파일을 저장하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF 저장됨')),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: AppColors.primary,
            ),
            child: const Text('저장'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
            child: const Text('취소'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF 저장 팝업 예제'),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showSaveDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          child: const Text(
            '확인',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
