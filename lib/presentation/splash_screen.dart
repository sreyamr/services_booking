import 'package:flutter/material.dart';
import 'package:service_booking/core/theme/app_color.dart';
import 'package:service_booking/core/theme/app_text_style.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Service icon
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.room_service,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
             Text(
              "Service Booking",
              style: AppTextStyles.poppinsBold(fontSize: 22)
            ),
            const SizedBox(height: 8),
             Text(
              "Book your favorite services instantly",
              textAlign: TextAlign.center,
             style: AppTextStyles.subtitle
            ),
            const SizedBox(height: 32),

          ],
        ),
      ),
    );
  }
}