import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/constant/colors.dart';

final FocusNode _focusNode = FocusNode();

class PhoneEditScreen extends StatefulWidget {
  final String initialPhone;

  const PhoneEditScreen({super.key, this.initialPhone = ''});

  @override
  State<PhoneEditScreen> createState() => _PhoneEditScreenState();
}

class _PhoneEditScreenState extends State<PhoneEditScreen>
    with WidgetsBindingObserver {
  late TextEditingController _controller;
  late String _originalPhone;
  bool _isChanged = false;
  double _keyboardHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // 숫자만 남기기
    _originalPhone = widget.initialPhone;
    _controller = TextEditingController(text: _originalPhone);

    _controller.addListener(() {
      final changed = _controller.text != _originalPhone;
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
    final result = _controller.text.trim();
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = _isChanged && _controller.text.trim().isNotEmpty;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  '전화번호를 입력해주세요',
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11),
                  ],
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '숫자만 입력해주세요',
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    if (isButtonEnabled) _onConfirm();
                  },
                ),
              ],
            ),
          ),

          if (_keyboardHeight > 0)
            Positioned(
              bottom: _keyboardHeight,
              left: 0,
              right: 0,
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: isButtonEnabled ? _onConfirm : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isButtonEnabled
                        ? AppColors.primary
                        : Colors.grey,
                    shape: RoundedRectangleBorder(), // 직각
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
            ),
        ],
      ),
    );
  }
}
