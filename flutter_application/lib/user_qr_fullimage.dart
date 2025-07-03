import 'package:flutter/material.dart';
import 'package:flutter_application/constant/colors.dart';

class UserQrFullImage extends StatefulWidget {
  final String imagePath;

  const UserQrFullImage({super.key, required this.imagePath});

  @override
  State<UserQrFullImage> createState() => _UserQrFullImageState();
}

class _UserQrFullImageState extends State<UserQrFullImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.pop(context), // 바깥 터치 시 닫기
        child: Stack(
          children: [
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: GestureDetector(
                  onTap: () {}, // 이미지 터치 시 팝업 닫히지 않도록 막기
                  child: Transform.rotate(
                    angle: -1.5708,
                    child: SizedBox(
                      width: screenHeight * 1,
                      height: screenWidth * 1,
                      child: Image.asset(widget.imagePath, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  size: 32,
                  color: AppColors.primary,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
