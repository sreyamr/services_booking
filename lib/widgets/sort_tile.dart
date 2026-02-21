import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_color.dart';
import '../core/theme/app_text_style.dart';

class SortTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const SortTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected
              ? AppColors.primary.withOpacity(0.08)
              : Colors.grey.shade100,
          border: Border.all(
            color: selected
                ? AppColors.primary
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: selected
                  ? AppColors.primary.withOpacity(0.15)
                  : Colors.grey.shade200,
              child: Icon(icon,
                  color: selected ? AppColors.primary : Colors.grey.shade700),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.title.copyWith(fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.body),
                ],
              ),
            ),

            if (selected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}