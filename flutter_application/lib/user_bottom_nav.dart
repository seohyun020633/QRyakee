import 'package:flutter/material.dart';
import 'package:flutter_application/profile_user.dart';
import 'package:flutter_application/user_home.dart';
import 'package:flutter_application/naver_map_screen.dart';
import 'package:flutter_application/constant/colors.dart';

//일반 사용자 하단바
class UserBottomNav extends StatefulWidget {
  @override
  State<UserBottomNav> createState() => _UserBottomNavState();
}

class _UserBottomNavState extends State<UserBottomNav> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = [
    UserHome(),
    NaverMapScreen(),
    Center(child: Text('이력 화면')),
    ProfileScreen(),
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
        onTap: _onItemTapped,
        selectedItemColor: AppColors.primary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '지도'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: '이력'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
      ),
    );
  }
}
