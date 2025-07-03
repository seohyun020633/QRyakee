import 'package:flutter/material.dart';
import 'package:flutter_application/constant/colors.dart';
import 'package:flutter_application/pharmacy_home.dart';
import 'package:flutter_application/pharmacy_chat.dart';
import 'package:flutter_application/pharmacy_search.dart';
import 'package:flutter_application/pharmacy_bottom_camera.dart';

class PharmacyBottomNav extends StatefulWidget {
  @override
  State<PharmacyBottomNav> createState() => _BottomNavState();
}


class _BottomNavState extends State<PharmacyBottomNav> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    PharmacyHome(),
    PharmacySearchPage(),
    PharmacyChat(),
    PharmacyQRCameraPage(),
  ];

  void _onItemTapped(int index) {
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
            icon: Icon(Icons.search),
            label: '검색',
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