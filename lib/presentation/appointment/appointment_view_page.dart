import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_color.dart';
import '../../core/theme/app_text_style.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/home_repository.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../routes/app_routes.dart';
import '../../widgets/show_confirm_dialog.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/bloc/auth_event.dart';
import '../dash_board/bloc/home_bloc.dart';
import '../dash_board/bloc/home_event.dart';
import '../dash_board/bloc/home_state.dart';
import 'bloc/appointment_bloc.dart';
import 'bloc/appointment_event.dart';
import 'bloc/appointment_state.dart';

class AppointmentBookingScreen extends StatelessWidget {
  const AppointmentBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseAuthService = FirebaseAuthService();
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (_) => HomeRepository()),
          RepositoryProvider(create: (_) => AuthRepository(firebaseAuthService)),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AppointmentBloc()
                ..add(LoadAppointments()),
            ),
            BlocProvider(
              create: (context) => HomeBloc(
                context.read<HomeRepository>(),
                context.read<AuthRepository>(),
              )..add(LoadHome()),
            ),
          ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.background,
          elevation: 0,
          title: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              final name = state.userName ?? "Guest";

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://cdn-icons-png.flaticon.com/128/11696/11696620.png"),
                        radius: 20,
                      ),
                      const SizedBox(width: 8),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Welcome, ",
                              style: AppTextStyles.title.copyWith(color: AppColors.textDark),
                            ),
                            TextSpan(
                              text: name,
                              style: AppTextStyles.title.copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),


                  IconButton(
                    icon:  const Icon(Icons.logout, color: AppColors.textPrimary),
                    tooltip: "Logout",
                    onPressed: () async {
                      final confirm = await showConfirmationDialog(
                        context: context,
                        title: "Logout",
                        content: "Are you sure you want to logout?",
                        confirmText: "Logout",
                        cancelText: "Cancel",
                      );
                      if (confirm != true) return;
                      context.read<AuthBloc>().add(LogoutRequested());

                      context.go(AppRoutes.login);
                    },
                  ),
                ],
              );
            },
          ),
        ),
        body: BlocBuilder<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
            if (state is AppointmentLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AppointmentLoaded) {
              final appointments = state.appointments;

              if (appointments.isEmpty) {
                return const Center(child: Text("No appointments found"));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: appointments.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final a = appointments[index];

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Top Row: User + Status + Switch
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 18,
                                  backgroundImage: NetworkImage(
                                    "https://cdn-icons-png.flaticon.com/128/847/847969.png",
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  a.userName,
                                  style: AppTextStyles.title.copyWith(fontSize: 16),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: a.status == 'approved'
                                        ? Colors.green.withOpacity(0.12)
                                        : Colors.orange.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    a.status.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: a.status == 'approved'
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Switch(
                                  value: a.status == 'approved',
                                  activeColor: AppColors.primary,
                                  onChanged: (val) {
                                    context.read<AppointmentBloc>().add(
                                      UpdateAppointmentStatus(
                                        bookingId: a.id,
                                        status: val ? 'approved' : 'pending',
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),
                        const Divider(height: 1),
                        const SizedBox(height: 12),

                        /// Provider
                        Row(
                          children: [
                            const Icon(Icons.person_outline,
                                size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              "Provider: ${a.providerName}",
                              style: AppTextStyles.body,
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        /// Date & Slot
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined,
                                size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('dd MMM yyyy').format(a.dateTime),
                              style: AppTextStyles.body,
                            ),
                            const Spacer(),
                            const Icon(Icons.access_time_outlined,
                                size: 18, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              a.slot,
                              style: AppTextStyles.body,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text("Something went wrong"));
            }
          },
        ),
      ),
        ));
  }
}