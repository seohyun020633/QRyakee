import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../constant/colors.dart';

import 'name_edit.dart';
import 'resident_edit.dart';
import 'phone_edit.dart';
// import 'medicine_edit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final picker = ImagePicker();

  String name = '홍길동';
  String resident = '900101-1';
  String phone = '01012345678';
  List<String> _medicines = [];

  String _formatResidentNumber(String raw) {
    if (raw.length < 8) return raw;
    return '${raw.substring(0, 8)}●●●●●●';
  }

  String _formatPhoneNumber(String raw) {
    if (raw.length == 11) {
      return '${raw.substring(0, 3)}-${raw.substring(3, 7)}-${raw.substring(7)}';
    } else if (raw.length == 10) {
      return '${raw.substring(0, 3)}-${raw.substring(3, 6)}-${raw.substring(6)}';
    }
    return raw;
  }

  Future<void> _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileData = [
      {
        'label': '이름',
        'value': name,
        'onTap': () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NameEditScreen(initialName: name),
            ),
          );
          if (result != null && result is String && mounted) {
            setState(() {
              name = result;
            });
          }
        },
      },
      {
        'label': '주민번호',
        'value': _formatResidentNumber(resident),
        'onTap': () => showResidentPopup(context),
      },
      {
        'label': '연락처',
        'value': _formatPhoneNumber(phone),
        'onTap': () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PhoneEditScreen(initialPhone: phone),
            ),
          );
          if (result != null && result is String && mounted) {
            setState(() {
              phone = result;
            });
          }
        },
      },
      {
        'label': '주기적으로 먹는 약',
        'value': _medicines.isEmpty ? '없음' : _medicines.join(', '),
        // 'onTap':
      },
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          '내 프로필',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
      body: Column(
        children: [
          // ✅ 위쪽 콘텐츠 (Padding으로 감싸기)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : null,
                        backgroundColor: Colors.grey[300],
                        child: _image == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _getImage,
                          child: const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 정보 항목들
                ...profileData.map(
                  (item) => buildInfoTile(
                    item['label'] as String,
                    item['value'] as String,
                    item['onTap'] as VoidCallback,
                  ),
                ),
              ],
            ),
          ),

          // ✅ 선: 전체 화면 너비로
          Container(
            width: double.infinity,
            height: 10,
            color: AppColors.lightgrey,
          ),

          // ✅ 자주 간 약국 타이틀
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '자주 간 약국',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // ✅ 약국 정보
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
            child: ListTile(
              leading: Icon(Icons.local_pharmacy),
              title: Text('행복한약국'),
              subtitle: Text('서울특별시 강남구 테헤란로'),
            ),
          ),

          const Spacer(),

          // ✅ 로그아웃 버튼
          Padding(
            padding: const EdgeInsets.only(right: 24.0, bottom: 24),
            child: Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  // 로그아웃 로직
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  '로그아웃',
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoTile(String label, String value, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IntrinsicWidth(
                  child: Text(label, style: const TextStyle(fontSize: 19)),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(fontSize: 17),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right, size: 27, color: AppColors.sub),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
