import 'package:flutter/material.dart';
import '../core/theme/app_color.dart';
import '../core/theme/app_text_style.dart';


Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String content,
  String confirmText = "Confirm",
  String cancelText = "Cancel",
  Color confirmColor = AppColors.primary,
  Color cancelColor = AppColors.textDark,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: AppTextStyles.poppinsSemiBold(fontSize: 18),
      ),
      content: Text(
        content,
        style: AppTextStyles.subtitle,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            cancelText,
            style: AppTextStyles.poppinsSemiBold(color: cancelColor),
          ),
        ),
      SizedBox(width: 25,),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            confirmText,
            style: AppTextStyles.poppinsSemiBold(color: AppColors.white),
          ),
        ),
      ],
    ),
  );
}