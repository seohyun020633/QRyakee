import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

//채팅 카메라

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    _controller = CameraController(
      cameras![0],
      ResolutionPreset.medium,
    );
    await _controller!.initialize();
    setState(() {
      _isReady = true;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('카메라')),
      body: CameraPreview(_controller!),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () async {
          final image = await _controller!.takePicture();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('사진 저장됨: ${image.path}')),
          );
        },
      ),
    );
  }
}