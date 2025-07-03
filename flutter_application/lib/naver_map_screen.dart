import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class NaverMapScreen extends StatefulWidget {
  const NaverMapScreen({super.key});

  @override
  State<NaverMapScreen> createState() => _NaverMapScreenState();
}

class _NaverMapScreenState extends State<NaverMapScreen> {
  bool _isInitialized = false;

  final FlutterNaverMap _naverMap = FlutterNaverMap();

  @override
  void initState() {
    super.initState();
    _initNaverMap();
  }

  Future<void> _initNaverMap() async {
    // 위치 권한 요청
    await _requestLocationPermission();
    // SDK 초기화
    await _naverMap.init(clientId: 'kwqacnm505');
    setState(() {
      _isInitialized = true;
    });
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: NaverMap(
        options: const NaverMapViewOptions(
          initialCameraPosition: NCameraPosition(
            target: NLatLng(37.5665, 126.9780),
            zoom: 14,
          ),
          locationButtonEnable: true,
          indoorEnable: true,
          consumeSymbolTapEvents: true,
        ),
        onMapReady: (controller) {
          debugPrint("네이버 지도 준비 완료");
        },
      ),
    );
  }
}
