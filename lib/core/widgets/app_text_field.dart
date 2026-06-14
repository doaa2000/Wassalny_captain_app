import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Reusable labeled text field matching the design's pill inputs.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.controller,
    this.hintText,
    this.prefix,
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.height = 54,
  });

  final String? label;
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefix;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final double height;

  @override
  Widget build(BuildContext context) {
    final Color border = context.isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final Color fill = context.isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTextStyles.label.copyWith(color: context.colors.onSurface)),
          const SizedBox(height: 8),
        ],
        Container(
          constraints: BoxConstraints(minHeight: height),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: border),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              if (prefix != null) ...[prefix!, const SizedBox(width: 10)],
              Expanded(
                child: TextFormField(
                  controller: controller,
                  obscureText: obscureText,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  validator: validator,
                  style: AppTextStyles.body.copyWith(
                    color: context.colors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: AppTextStyles.body.copyWith(color: AppColors.textMutedDark),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              if (suffix != null) ...[const SizedBox(width: 10), suffix!],
            ],
          ),
        ),
      ],
    );
  }
}
