import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Four-box OTP entry that reports the full code via [onChanged].
class OtpInput extends StatefulWidget {
  const OtpInput({super.key, this.length = 4, required this.onChanged});

  final int length;
  final ValueChanged<String> onChanged;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < widget.length - 1) {
      _nodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    widget.onChanged(_controllers.map((c) => c.text).join());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(widget.length, (i) {
        final bool focused = _nodes[i].hasFocus || _controllers[i].text.isNotEmpty;
        return Padding(
          padding: EdgeInsets.only(right: i == widget.length - 1 ? 0 : 14),
          child: SizedBox(
            width: 64,
            height: 70,
            child: TextField(
              controller: _controllers[i],
              focusNode: _nodes[i],
              onChanged: (v) => _onChanged(i, v),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: AppTextStyles.title.copyWith(color: AppColors.textPrimaryDark, fontSize: 28),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: focused ? AppColors.primary.withValues(alpha: 0.1) : AppColors.darkSurface,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: AppColors.darkBorder, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
