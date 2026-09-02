import 'package:flutter/material.dart';
import 'package:wassalny_captain/l10n/app_localizations.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Phone input prefixed with the Egyptian flag + dial code, as in the design.
class PhoneField extends StatelessWidget {
  const PhoneField({super.key, this.controller, this.label});

  final TextEditingController? controller;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AppTextField(
      label: label ?? l.phoneLabel,
      controller: controller,
      keyboardType: TextInputType.phone,
      prefix: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: const SizedBox(
              width: 20,
              height: 14,
              child: Column(
                children: [
                  Expanded(child: ColoredBox(color: Color(0xFFCE1126))),
                  Expanded(child: ColoredBox(color: Colors.white)),
                  Expanded(child: ColoredBox(color: Colors.black)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            AppConstants.dialCode,
            style: AppTextStyles.bodyStrong.copyWith(color: AppColors.textPrimaryDark),
          ),
          const SizedBox(width: 10),
          Container(width: 1, height: 22, color: AppColors.darkBorder),
        ],
      ),
    );
  }
}
