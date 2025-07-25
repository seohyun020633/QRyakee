import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constant/colors.dart';
import '../constant/city_map.dart';
import '../constant/input_styles.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'signup_pharmacy_screen',
      home: const PharmacySignupScreen(),
    );
  }
}


class PharmacySignupScreen extends StatefulWidget {
  const PharmacySignupScreen({super.key});

  @override
  State<PharmacySignupScreen> createState() => _PharmacySignupScreenState();
}

class _PharmacySignupScreenState extends State<PharmacySignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _pharmacyNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwConfirmController = TextEditingController();

  String? _selectedCity;
  String? _selectedDistrict;

  final List<String> _cities = cityDistrictMap.keys.toList();

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      print('약국 이름: ${_pharmacyNameController.text}');
      print('연락처: ${_phoneController.text}');
      print('주소: $_selectedCity $_selectedDistrict');
      print('아이디: ${_idController.text}');
    }
  }

  @override
  void dispose() {
    _pharmacyNameController.dispose();
    _phoneController.dispose();
    _idController.dispose();
    _pwController.dispose();
    _pwConfirmController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      floatingLabelStyle: const TextStyle(color: Colors.blueGrey),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      border: const OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '약국 회원가입',
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
                controller: _pharmacyNameController,
                cursorColor: Colors.blueGrey,
                decoration: buildInputDecoration(hint: '약국 이름'),
                validator: (value) => value!.isEmpty ? '약국 이름을 입력하세요.' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                cursorColor: Colors.blueGrey,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(13),
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
                          .map((city) => DropdownMenuItem(
                                value: city,
                                child: Text(city),
                              ))
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
                          .map((district) => DropdownMenuItem(
                                value: district,
                                child: Text(district),
                              ))
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
              const Divider(height: 32, thickness: 1, color: Colors.grey),
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
                  child: const Text('회원가입', style: TextStyle(fontSize: 15, color: Colors.white)),
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
