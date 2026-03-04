import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:service_booking/presentation/appointment/appointment_view_page.dart';

import '../data/models/category_model.dart';
import '../presentation/auth/bloc/auth_bloc.dart';
import '../presentation/auth/login_page.dart';
import '../presentation/auth/signup_page.dart';
import '../presentation/booking/bloc/booking_bloc.dart';
import '../presentation/dash_board/home_page.dart';
import '../presentation/dash_board/main_screen.dart';
import '../presentation/dash_board/providers_details_screen.dart';
import '../presentation/splash_screen.dart';
import 'app_routes.dart';
import '../presentation/auth/bloc/auth_state.dart';


class AppRouter {
  static GoRouter router(AuthBloc authBloc) {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),

      redirect: (context, state) {
        final authState = authBloc.state;

        final onSplash = state.matchedLocation == AppRoutes.splash;
        final onLogin = state.matchedLocation == AppRoutes.login;
        final onSignup = state.matchedLocation == AppRoutes.signup;

        // Splash logic
        if (onSplash) {
          if (authState is AuthAuthenticated) {
            return authState.user.role == 'admin'
                ? AppRoutes.adminAppointments
                : AppRoutes.home;
          }
          if (authState is AuthUnauthenticated) return AppRoutes.login;
        }

        // Authenticated users should not go to login or signup
        if (authState is AuthAuthenticated && (onLogin || onSignup)) {
          return authState.user.role == 'admin'
              ? AppRoutes.adminAppointments
              : AppRoutes.home;
        }

        // Unauthenticated users should not be redirected from signup
        if (authState is AuthUnauthenticated && !onLogin && !onSignup) {
          return AppRoutes.login;
        }

        return null; // no redirect
      },
      routes: [

        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRoutes.signup,
          builder: (context, state) => const SignupPage(),
        ),
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => HomePageWrapper(),
        ), GoRoute(
          path: AppRoutes.adminAppointments,
          builder: (context, state) => const AppointmentBookingScreen(),
        ),
        GoRoute(
          path: AppRoutes.details,
          builder: (context, state) {
            final args = state.extra as ProviderDetailArgs;

            return BlocProvider(
              create: (_) => BookingBloc(),
              child: ProviderDetailScreen(
                provider: args.provider,
                userName: args.userName,
              ),
            );
          },
        ),
      ],
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}