
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constant/colors.dart';
import '../constant/city_map.dart';

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
  final TextEditingController _residentFrontController = TextEditingController();
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

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
     final residentNumber = "${_residentFrontController.text}-${_residentBackController.text}******";

      print("이름: ${_nameController.text}");
      print("주민번호: $residentNumber");
      print("연락처: ${_phoneController.text}");
      print("주소: $_selectedCity $_selectedDistrict");
      print("약 복용 여부: ${_takesMedicine ? _medicineController.text : "없음"}");
      print("아이디: ${_idController.text}");
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
        title: const Text('사용자 회원가입'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: '이름',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? '이름을 입력하세요.' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _residentFrontController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      decoration: const InputDecoration(
                        labelText: '주민번호 앞자리',
                        hintText: '예: 900101',
                        border: OutlineInputBorder(),
                      ),
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
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                      decoration: const InputDecoration(
                        labelText: '뒷자리 첫 숫자',
                        border: OutlineInputBorder(),
                      ),
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
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(13), // 최대 길이 제한
                  PhoneNumberFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText: '연락처',
                  hintText: '000-0000-0000',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final phoneReg = RegExp(r'^\\d{3}-\\d{4}-\\d{4}\$');
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
                      decoration: const InputDecoration(
                        labelText: '시/도',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedCity,
                      items: _cities.map((city) {
                        return DropdownMenuItem(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCity = value;
                          _selectedDistrict = null;
                        });
                      },
                      validator: (value) => value == null ? '시/도를 선택하세요.' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: '구/군',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedDistrict,
                      items: (_selectedCity != null
                          ? cityDistrictMap[_selectedCity]!
                          : <String>[]).map((district) {
                        return DropdownMenuItem(
                          value: district,
                          child: Text(district),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDistrict = value;
                        });
                      },
                      validator: (value) => value == null ? '구/군을 선택하세요.' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('주기적으로 먹는 약이 있나요?', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _takesMedicine,
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
                  decoration: const InputDecoration(
                    labelText: '복용 중인 약 이름',
                    border: OutlineInputBorder(),
                  ),
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
                decoration: const InputDecoration(
                  labelText: '아이디',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? '아이디를 입력하세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pwController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? '비밀번호를 입력하세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pwConfirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: '비밀번호 재입력',
                  border: OutlineInputBorder(),
                ),
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
                    style: TextStyle(fontSize: 16),
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
      formatted = '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7)}';
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