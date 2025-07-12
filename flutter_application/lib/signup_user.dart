import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constant/colors.dart';
import '../constant/city_map.dart';
import '../constant/input_styles.dart';
import '../services/call_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'signup_user_screen',
      home: const UserSignupScreen(),
    );
  }
}

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({super.key});

  @override
  State<UserSignupScreen> createState() => _UserSignupScreenState();
}

class _UserSignupScreenState extends State<UserSignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _residentFrontController =
      TextEditingController();
  final TextEditingController _residentBackController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwConfirmController = TextEditingController();
  final TextEditingController _medicineController = TextEditingController();

  String? _selectedCity;
  String? _selectedDistrict;
  bool _takesMedicine = false;

  final List<String> _cities = cityDistrictMap.keys.toList();

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        "user_name": _nameController.text,
        "resident_number":
            "${_residentFrontController.text}-${_residentBackController.text}******",
        "phone": _phoneController.text,
        "city": _selectedCity,
        "district": _selectedDistrict,
        "takes_medicine": _takesMedicine,
        "medicine_name": _takesMedicine ? _medicineController.text : null,
        "user_id": _idController.text,
        "user_password": _pwController.text,
      };

      try {
        final response = await ApiService.userSignup(data);
        if (response.statusCode == 200) {
          print("회원가입 성공");
        } else {
          print("회원가입 실패: ${response.body}");
        }
      } catch (e) {
        print("에러 발생: $e");
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _residentFrontController.dispose();
    _residentBackController.dispose();
    _phoneController.dispose();
    _idController.dispose();
    _pwController.dispose();
    _pwConfirmController.dispose();
    _medicineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '사용자 회원가입',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                cursorColor: Colors.blueGrey,
                decoration: buildInputDecoration(hint: '이름'),
                validator: (value) => value!.isEmpty ? '이름을 입력하세요.' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _residentFrontController,
                      cursorColor: Colors.blueGrey,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: buildInputDecoration(hint: '예: 900101'),
                      validator: (value) =>
                          value!.length != 6 ? '앞 6자리를 입력하세요.' : null,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('-', style: TextStyle(fontSize: 20)),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: _residentBackController,
                      cursorColor: Colors.blueGrey,
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                      decoration: buildInputDecoration(hint: '뒷자리 첫숫자'),
                      validator: (value) =>
                          value!.length != 1 ? '1자리를 입력하세요.' : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('●●●●●●', style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                cursorColor: Colors.blueGrey,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(13), // 최대 길이 제한
                  PhoneNumberFormatter(),
                ],
                decoration: buildInputDecoration(hint: '000-0000-0000'),
                validator: (value) {
                  final phoneReg = RegExp(r'^\d{3}-\d{4}-\d{4}$');
                  if (value == null || !phoneReg.hasMatch(value)) {
                    return '형식: 000-0000-0000';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCity,
                      decoration: buildInputDecoration(hint: '시/도'),
                      items: _cities
                          .map(
                            (city) => DropdownMenuItem(
                              value: city,
                              child: Text(city),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCity = value;
                          _selectedDistrict = null;
                        });
                      },
                      validator: (value) =>
                          value == null ? '시/도를 선택하세요.' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedDistrict,
                      decoration: buildInputDecoration(hint: '구/군'),
                      items: (cityDistrictMap[_selectedCity] ?? [])
                          .map(
                            (district) => DropdownMenuItem(
                              value: district,
                              child: Text(district),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDistrict = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? '구/군을 선택하세요.' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '주기적으로 먹는 약이 있나요?',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _takesMedicine,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          setState(() {
                            _takesMedicine = value!;
                          });
                        },
                      ),
                      const Text('예'),
                      const SizedBox(width: 16),
                      Radio<bool>(
                        value: false,
                        groupValue: _takesMedicine,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          setState(() {
                            _takesMedicine = value!;
                          });
                        },
                      ),
                      const Text('아니요'),
                    ],
                  ),
                ],
              ),

              if (_takesMedicine)
                TextFormField(
                  controller: _medicineController,
                  cursorColor: Colors.blueGrey,
                  decoration: buildInputDecoration(hint: '복용 중인 약 이름'),
                  validator: (value) =>
                      _takesMedicine && value!.isEmpty ? '약 이름을 입력하세요.' : null,
                ),
              if (_takesMedicine) const SizedBox(height: 16),

              const Divider(
                height: 32,
                thickness: 1,
                color: Colors.grey, // 원하는 색상으로 바꿀 수 있음
              ),

              TextFormField(
                controller: _idController,
                cursorColor: Colors.blueGrey,
                decoration: buildInputDecoration(hint: '아이디'),
                validator: (value) => value!.isEmpty ? '아이디를 입력하세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pwController,
                cursorColor: Colors.blueGrey,
                obscureText: true,
                decoration: buildInputDecoration(hint: '비밀번호'),
                validator: (value) => value!.isEmpty ? '비밀번호를 입력하세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pwConfirmController,
                cursorColor: Colors.blueGrey,
                obscureText: true,
                decoration: buildInputDecoration(hint: '비밀번호 재입력'),
                validator: (value) {
                  if (value!.isEmpty) return '비밀번호를 재입력하세요.';
                  if (value != _pwController.text) return '비밀번호가 일치하지 않습니다.';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSignup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    '회원가입',
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    String formatted = '';

    if (digits.length <= 3) {
      formatted = digits;
    } else if (digits.length <= 7) {
      formatted = '${digits.substring(0, 3)}-${digits.substring(3)}';
    } else if (digits.length <= 11) {
      formatted =
          '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7)}';
    } else {
      formatted =
          '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7, 11)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
