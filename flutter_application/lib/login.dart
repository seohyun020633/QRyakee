import 'package:flutter/material.dart';
import '../constant/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  bool _isUser = true;

  void _handleLogin() {
    final id = _idController.text.trim();
    final pw = _pwController.text.trim();
    // 로그인 처리 로직
    print('로그인 유형: ${_isUser ? '회원' : '약국'}, ID: $id, PW: $pw');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isUser = true),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _isUser ? AppColors.primary : Colors.white,
                          border: Border.all(color: Colors.black12),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          '회원',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _isUser ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isUser = false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: !_isUser ? AppColors.primary : Colors.white,
                          border: Border.all(color: Colors.black12),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          '약국',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: !_isUser ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                _isUser ? '회원 로그인' : '약국 로그인',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pwController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'PW',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text('로그인'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
