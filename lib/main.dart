import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:service_booking/presentation/auth/bloc/auth_event.dart';

import 'data/services/firebase_auth_service.dart';
import 'firebase_options.dart';
import 'routes/app_router.dart';
import 'presentation/auth/bloc/auth_bloc.dart';
import 'data/repositories/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthBloc(AuthRepository(FirebaseAuthService()))..add(CheckSession()),
      child: Builder(
        builder: (context) {
          final router = AppRouter.router(context.read<AuthBloc>());

          return MaterialApp.router(
            title: 'Service Booking',
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            theme: ThemeData(
              useMaterial3: true,
            ),
          );
        },
      ),
    );
  }
}

