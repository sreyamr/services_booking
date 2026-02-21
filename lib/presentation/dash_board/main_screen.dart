import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../Notification/notification_page.dart';
import '../booking/booking_page.dart';
import '../profile/profile_screen.dart';
import 'bottom_nav_bar/bloc/bottom_nav_bloc.dart';
import 'home_page.dart';


class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static final List<Widget> pages = [
    HomePage(),
    BookingPage(),
    NotificationPage(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavBloc(),
      child: BlocBuilder<BottomNavBloc, BottomNavState>(
        builder: (context, state) {
          return Scaffold(
            body: pages[state.selectedIndex],
            bottomNavigationBar: const AppBottomNavBar(),
          );
        },
      ),
    );
  }
}