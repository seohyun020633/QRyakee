import 'package:flutter/material.dart';
import 'package:flutter_application/constant/colors.dart';
import 'package:flutter_application/pharmacy_camera.dart';

class PharmacyChat extends StatefulWidget {
  const PharmacyChat({super.key});

  @override
  State<PharmacyChat> createState() => _PharmacyChatState();
}

class _PharmacyChatState extends State<PharmacyChat> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  void _showPrescriptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('처방전 상세 정보', style: TextStyle(fontSize: 20)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('환자 이름:', style: TextStyle(fontSize: 17)),
            Text('주민번호:7자리', style: TextStyle(fontSize: 17)),
            Text('교부일자:', style: TextStyle(fontSize: 17)),
            Text('교부번호:', style: TextStyle(fontSize: 17)),
            Text('복용약 정보', style: TextStyle(fontSize: 17)),
          ],
        ),
        actions: [
          TextButton(
            child: const Text(
              '닫기',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    String message = _controller.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(message);
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          '채팅',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
      body: Column(
        children: [
          // 사용자에게 전달 받음
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: const [
                Icon(Icons.account_circle, size: 40, color: AppColors.primary),
                SizedBox(width: 12),
                Text(
                  '복용자 이름'
                  '\t'
                  '님',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 처방전 -> 클릭 가능
          GestureDetector(
            onTap: () => _showPrescriptionDialog(context),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary),
              ),
              child: const Text(
                '2025-06-30\n교부번호: A123456\n해당 처방전에 대한 상담입니다.',
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),

          const Divider(height: 1),
          // 메시지 리스트
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _messages[index],
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                );
              },
            ),
          ),

          // 채팅 입력 바
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            color: Colors.grey[100],
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CameraScreen()),
                    );
                  },
                ),

                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '메시지를 입력하세요',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),

                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: AppColors.primary),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
