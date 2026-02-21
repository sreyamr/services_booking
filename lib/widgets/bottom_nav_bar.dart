import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_booking/core/theme/app_color.dart';
import 'package:service_booking/core/theme/app_text_style.dart';
import '../presentation/dash_board/bottom_nav_bar/bloc/bottom_nav_bloc.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBloc, BottomNavState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.selectedIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          selectedLabelStyle: AppTextStyles.subtitle,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            context.read<BottomNavBloc>().add(ChangeBottomNav(index));
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_online),
              label: "Booking",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: "Notification",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        );
      },
    );
  }
}