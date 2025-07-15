import 'package:flutter/material.dart';
import 'package:flutter_application/services/call_api.dart';
import '../constant/colors.dart';
import 'package:flutter_application/user_bottom_nav.dart';
import 'package:flutter_application/pharmacy_bottom_nav.dart';
import '../constant/input_styles.dart'; // 추가

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  String _loginErrorMessage = '';
  bool _isUser = true;

  void _handleLogin() async {
    final id = _idController.text.trim();
    final pw = _pwController.text.trim();

    if (id.isEmpty || pw.isEmpty) {
      setState(() => _loginErrorMessage = '아이디와 비밀번호를 입력해주세요.');
      return;
    }

    try {
      final response = _isUser
          ? await ApiService.loginUser(id, pw)
          : await ApiService.loginPharmacy(id, pw);

      if (response.statusCode == 200) {
        setState(() => _loginErrorMessage = '');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                _isUser ? UserBottomNav() : PharmacyBottomNav(),
          ),
        );
      } else {
        setState(() => _loginErrorMessage = '아이디 또는 비밀번호가 올바르지 않습니다.');
      }
    } catch (e) {
      setState(() => _loginErrorMessage = '서버에 연결할 수 없습니다.');
    }
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _idController,
                decoration: buildInputDecoration(hint: 'ID'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pwController,
                obscureText: true,
                decoration: buildInputDecoration(hint: 'PW'),
              ),
              if (_loginErrorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _loginErrorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
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
