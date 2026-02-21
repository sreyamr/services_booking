import 'package:flutter/material.dart';
import '../core/theme/app_color.dart';
import '../core/theme/app_text_style.dart';

class AppButton extends StatelessWidget {
  final String text;
  final bool loading;
  final VoidCallback? onTap;

  const AppButton({
    super.key,
    required this.text,
    this.loading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (loading) return;        // prevent double click
          onTap?.call();              // safe call (no crash if null)
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary, // always active color
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: loading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : Text(text, style: AppTextStyles.button),
      ),
    );
  }
}