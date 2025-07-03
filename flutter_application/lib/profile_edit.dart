import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constant/colors.dart';

class ProfileEditScreen extends StatefulWidget {
  final String name;
  final String resident;
  final String phone;
  final List<String> medicines;

  const ProfileEditScreen({
    super.key,
    required this.name,
    required this.resident,
    required this.phone,
    required this.medicines,
  });

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _nameController;
  late TextEditingController _residentController;
  late TextEditingController _phoneController;
  List<TextEditingController> _medicineControllers = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _residentController = TextEditingController(text: widget.resident);
    _phoneController = TextEditingController(text: widget.phone);
    _medicineControllers = widget.medicines
        .map((m) => TextEditingController(text: m))
        .toList();

    if (_medicineControllers.isEmpty) {
      _medicineControllers.add(TextEditingController());
    }
  }

  void _addMedicineField() {
    setState(() {
      _medicineControllers.add(TextEditingController());
    });
  }

  void _saveProfile() {
    Navigator.pop(context, {
      'name': _nameController.text,
      'resident': _residentController.text,
      'phone': _phoneController.text,
      'medicines': _medicineControllers
          .map((c) => c.text)
          .where((t) => t.isNotEmpty)
          .toList(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '프로필 수정',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '이름'),
            ),
            TextField(
              controller: _residentController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                LengthLimitingTextInputFormatter(8),
              ],
              decoration: const InputDecoration(
                labelText: '주민번호 (앞 7자리)',
                hintText: '예: 900101-1',
              ),
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(13),
                _PhoneNumberFormatter(),
              ],
              decoration: const InputDecoration(
                labelText: '연락처',
                hintText: '예: 010-1234-5678',
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '주기적으로 먹는 약',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._medicineControllers.map(
              (controller) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '약 이름',
                  ),
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _addMedicineField,
              icon: const Icon(Icons.add),
              label: const Text('약 추가'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 연락처 자동 하이픈 입력 포매터
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
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
