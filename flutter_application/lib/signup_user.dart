import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/first.dart';
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
  bool _isUserIdChecked = false; // 중복 확인 버튼 눌렀는지
  bool? _isUserIdAvailable; // null: 아직 안 눌렀음, true: 사용 가능, false: 중복
  String _userIdCheckMessage = ''; // 안내 메시지
  bool _takesMedicine = false;

  final List<String> _cities = cityDistrictMap.keys.toList();

  void _checkUserId() async {
    final userId = _idController.text.trim();
    _isUserIdChecked = true; // 버튼 누름 상태 표시

    if (userId.length < 4) {
      setState(() {
        _isUserIdAvailable = false;
        _userIdCheckMessage = "아이디는 4자 이상이어야 합니다.";
      });
      return;
    }

    try {
      final response = await ApiService.checkUserId(userId);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final exists = data['exists'] as bool;

        setState(() {
          _isUserIdAvailable = !exists;
          _userIdCheckMessage = exists ? "이미 존재하는 아이디입니다." : "사용 가능한 아이디입니다.";
        });
      } else {
        setState(() {
          _isUserIdAvailable = false;
          _userIdCheckMessage = "서버 오류가 발생했습니다.";
        });
      }
    } catch (e) {
      setState(() {
        _isUserIdAvailable = false;
        _userIdCheckMessage = "에러가 발생했습니다.";
      });
    }
  }

  void _handleSignup() async {
  // 1. null 체크 
  if (_nameController.text.isEmpty) {
    FocusScope.of(context).requestFocus(FocusNode());
    _formKey.currentState!.validate();
    return;
  }
  if (_residentFrontController.text.isEmpty || _residentFrontController.text.length != 6) {
    FocusScope.of(context).requestFocus(FocusNode());
    _formKey.currentState!.validate();
    return;
  }
  if (_residentBackController.text.isEmpty || _residentBackController.text.length != 1) {
    FocusScope.of(context).requestFocus(FocusNode());
    _formKey.currentState!.validate();
    return;
  }
  if (_phoneController.text.isEmpty) {
    FocusScope.of(context).requestFocus(FocusNode());
    _formKey.currentState!.validate();
    return;
  }
  if (_selectedCity == null) {
    _formKey.currentState!.validate();
    return;
  }
  if (_selectedDistrict == null) {
    _formKey.currentState!.validate();
    return;
  }
  if (_takesMedicine && _medicineController.text.isEmpty) {
    _formKey.currentState!.validate();
    return;
  }
  if (_idController.text.isEmpty) {
    _formKey.currentState!.validate();
    return;
  }
  if (_pwController.text.isEmpty) {
    _formKey.currentState!.validate();
    return;
  }
  if (_pwConfirmController.text.isEmpty) {
    _formKey.currentState!.validate();
    return;
  }

  // 2. 아이디 중복 확인
  if (!_isUserIdChecked || _isUserIdAvailable == false) {
    setState(() {
      _userIdCheckMessage = "아이디 중복을 확인해주세요.";
    });
    return;
  } else {
    setState(() {
      _userIdCheckMessage = ""; 
    });
  }

  // 3. 비밀번호 복잡성 체크
  final pw = _pwController.text;
  final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(pw);
  final hasNumber = RegExp(r'\d').hasMatch(pw);
  final hasSpecial = RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(pw);
  if (pw.length < 6 || !hasLetter || !hasNumber || !hasSpecial) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("비밀번호는 영문, 숫자, 특수문자를 각각 1자 이상 포함하고 6자리 이상이어야 합니다.")),
    );
    return;
  }

  // 4.비밀번호 일치 체크
  if (_pwController.text != _pwConfirmController.text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("비밀번호가 일치하지 않습니다.")),
    );
    return;
  }

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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const FirstScreen()),
        );
      } else {
        if (response.statusCode == 409) {
          _showPopupAndGoHome("이미 등록되어있는 전화번호입니다.");
        } else {
          _showPopupAndGoHome("회원가입 중 오류가 발생했습니다.");
        }
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
    final bool isIdError =
        (_isUserIdChecked && _isUserIdAvailable == false) ||
        (!_isUserIdChecked && _userIdCheckMessage.isNotEmpty);

    final bool isIdValid = _isUserIdChecked && _isUserIdAvailable == true;

    Color borderColor;
    if (isIdError) {
      borderColor = Colors.red;
    } else if (isIdValid) {
      borderColor = AppColors.primary;
    } else {
      borderColor = Colors.grey;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
              SizedBox(
                height: 53,
                child: TextFormField(
                  controller: _nameController,
                  cursorColor: Colors.blueGrey,
                  decoration: buildInputDecoration(hint: '이름'),
                  validator: (value) => value == null || value.isEmpty ? '이름을 입력하세요.' : null,
                ),
              ),  
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 53,
                      child: TextFormField(
                        controller: _residentFrontController,
                        cursorColor: Colors.blueGrey,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        decoration: buildInputDecoration(hint: '예: 990101'),
                        validator: (value) =>
                            value!.length != 6 ? '앞 6자리를 입력하세요.' : null,
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('-', style: TextStyle(fontSize: 20)),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 53,
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
                            value!.length != 1 ? '필수' : null,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),
                  const Text('●●●●●●', style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 16),
             SizedBox(
                height: 53,
                child: TextFormField(
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
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 53,
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
                  ),

                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 53,
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
                SizedBox(
                  height: 53,
                  child: TextFormField(
                    controller: _medicineController,
                    cursorColor: Colors.blueGrey,
                    decoration: buildInputDecoration(hint: '복용 중인 약 이름'),
                    validator: (value) =>
                        _takesMedicine && value!.isEmpty ? '약 이름을 입력하세요.' : null,
                  ),
                ),

              if (_takesMedicine) const SizedBox(height: 16),

              const Divider(
                height: 32,
                thickness: 1,
                color: Colors.grey, 
              ),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 53,
                      child: TextFormField(
                        controller: _idController,
                        cursorColor: Colors.blueGrey,
                        style: const TextStyle(fontSize: 16),
                        decoration: buildInputDecoration(hint: '아이디'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '아이디를 입력하세요.';         
                          }
                          if (value.length < 4) {
                            return '아이디는 4자 이상이어야 합니다.'; 
                          }
                          if (!_isUserIdChecked) {
                            return '아이디 중복 확인을 해주세요.';     
                          }
                          if (_isUserIdAvailable == false) {
                            return _userIdCheckMessage;              
                          }
                          return null; // 정상
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _checkUserId,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(73, 53),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    child: Text(
                      "중복확인",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              SizedBox(
                height: 53,
                child: TextFormField(
                  controller: _pwController,
                  cursorColor: Colors.blueGrey,
                  obscureText: true,
                  decoration: buildInputDecoration(hint: '비밀번호'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해주세요.';
                    }

                    if (value.length < 6) {
                      return '최소 6자리 이상이어야 합니다.';
                    }

                    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
                    final hasNumber = RegExp(r'\d').hasMatch(value);
                    final hasSpecial = RegExp(
                      r'[!@#\$%^&*(),.?":{}|<>]',
                    ).hasMatch(value);

                    if (!hasLetter || !hasNumber || !hasSpecial) {
                      return '영문, 숫자, 특수문자 각각 1자 이상 포함해야 합니다.';
                    }

                    return null;
                  },
                ),
              ),

              const SizedBox(height: 16),
              SizedBox(
                height: 53,
                child: TextFormField(
                  controller: _pwConfirmController,
                  cursorColor: Colors.blueGrey,
                  obscureText: true,
                  decoration: buildInputDecoration(hint: '비밀번호 재입력'),
                  validator: (value) {
                    if (value!.isEmpty) return '비밀번호를 재입력하세요.';
                    if (value.isEmpty) {
                      return '비밀번호를 입력해주세요.';
                    }

                    if (value.length < 6) {
                      return '최소 6자리 이상이어야 합니다.';
                    }

                    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
                    final hasNumber = RegExp(r'\d').hasMatch(value);
                    final hasSpecial = RegExp(
                      r'[!@#\$%^&*(),.?":{}|<>]',
                    ).hasMatch(value);

                    if (!hasLetter || !hasNumber || !hasSpecial) {
                      return '영문, 숫자, 특수문자 각각 1자 이상 포함해야 합니다.';
                    }
                    if (value != _pwController.text) return '비밀번호가 일치하지 않습니다.';
                    return null;
                  },
                ),
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

  void _showPopupAndGoHome(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4), // 배경 불투명하게
      builder: (context) => AlertDialog(
        title: const Text('오류'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 팝업 닫기
              Navigator.of(context).pop(); // 홈 화면으로 이동
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  Color _getUserIdBorderColor() {
    if (_isUserIdChecked) {
      if (_isUserIdAvailable == false) {
        return Colors.red;
      } else if (_isUserIdAvailable == true) {
        return AppColors.primary;
      }
    }
    return Colors.grey;
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