import 'package:flutter/material.dart';
import 'package:flutter_application/constant/colors.dart';

final FocusNode _focusNode = FocusNode();

class NameEditScreen extends StatefulWidget {
  final String initialName;

  const NameEditScreen({super.key, this.initialName = ''});

  @override
  State<NameEditScreen> createState() => _NameEditScreenState();
}

class _NameEditScreenState extends State<NameEditScreen>
    with WidgetsBindingObserver {
  late TextEditingController _controller;
  late String _originalName;
  bool _isChanged = false;
  double _keyboardHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _originalName = widget.initialName;
    _controller = TextEditingController(text: _originalName);

    _controller.addListener(() {
      final text = _controller.text.trim();
      final changed = text.isNotEmpty && text != _originalName;
      if (changed != _isChanged) {
        setState(() {
          _isChanged = changed;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    setState(() {
      _keyboardHeight =
          bottomInset / WidgetsBinding.instance.window.devicePixelRatio;
    });
  }

  void _onConfirm() {
    Navigator.pop(context, _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드가 올라와도 리사이즈 방지
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '이름을 입력해주세요',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    if (_isChanged) _onConfirm();
                  },
                ),
              ],
            ),
          ),

          // 키보드 위 버튼
          if (_keyboardHeight > 0)
            Positioned(
              bottom: _keyboardHeight + 1, // 10픽셀 띄워서 좀 더 높게
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: _isChanged ? _onConfirm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isChanged ? AppColors.primary : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 18), // 높이 더 크게
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text(
                  '확인',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
