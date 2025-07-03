import 'package:flutter/material.dart';
import 'package:flutter_application/constant/colors.dart';
import 'package:flutter_application/pharmacy_home.dart';
import 'package:flutter_application/pharmacy_chat.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_application/pharmacy_linkview.dart';
import 'package:flutter_application/pharmacy_bottom_camera.dart';

class PharmacyBottomNav extends StatefulWidget {
  @override
  State<PharmacyBottomNav> createState() => _BottomNavState();
}

Future<void> _launchURL() async {
  final url = Uri.parse('https://www.example.com');
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

class _BottomNavState extends State<PharmacyBottomNav> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    PharmacyHome(),
    Center(child: Text('')),
    PharmacyChat(),
    PharmacyQRCameraPage(),
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const WebViewPage(
          url: 'https://nedrug.mfds.go.kr/index',
          title: '의약품 안전나라',
        ),
      ),
    );
    return;
  }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.link),
            label: '링크',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: '카메라',
          ),
        ],
      ),
    );
  }
}