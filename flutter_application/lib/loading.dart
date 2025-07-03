import 'package:flutter/material.dart';
import '../constant/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '애니메이션 로딩 화면',
      debugShowCheckedModeBanner: false,
      home: const AnimatedLoadingScreen(),
    );
  }
}

class AnimatedLoadingScreen extends StatefulWidget {
  const AnimatedLoadingScreen({super.key});

  @override
  State<AnimatedLoadingScreen> createState() => _AnimatedLoadingScreenState();
}

class _AnimatedLoadingScreenState extends State<AnimatedLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.local_pharmacy, color: Colors.white, size: 60),
              SizedBox(height: 20),
        
            ],
          ),
        ),
      ),
    );
  }
}
