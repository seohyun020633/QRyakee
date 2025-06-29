import 'package:flutter/material.dart';
import '../constant/colors.dart';

class SignupSelectionScreen extends StatelessWidget {
  const SignupSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입 유형 선택'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '회원가입 유형을 선택하세요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/signup/pharmacy');
              },
              child: const Text('약국으로 가입'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/signup/user');
              },
              child: const Text('사용자로 가입'),
            ),
          ],
        ),
      ),
    );
  }
}
