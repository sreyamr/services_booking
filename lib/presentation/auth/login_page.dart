import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_color.dart';
import '../../core/theme/app_text_style.dart';
import '../../core/validator.dart';
import '../../routes/app_routes.dart';
import '../../widgets/app_button.dart';
import '../../widgets/text_fields.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.message)));
              }

              if (state is AuthAuthenticated) {
                final isAdmin = state.user.role == 'admin';

                if (isAdmin) {
                  context.push(AppRoutes.adminAppointments);
                } else {
               //   context.push(AppRoutes.home);
                }
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),


                  const SizedBox(height: 20),
                  Text('Welcome back', style: AppTextStyles.title),
                  const SizedBox(height: 4),
                  Text('Enter your credential to continue',
                      style: AppTextStyles.body),

                  const SizedBox(height: 24),
                  AppTextField(
                    controller: emailCtrl,
                    hint: 'Email',
                    icon: Icons.person_outline,
                    validator: SignupValidator.email,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: passCtrl,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,

                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Forgot password?'),
                    ),
                  ),

                  const SizedBox(height: 50),
                  AppButton(
                    text: 'Log in',
                    loading: state is AuthLoading,
                    onTap: () {
                      context.read<AuthBloc>().add(
                        LoginRequested(
                          emailCtrl.text.trim(),
                          passCtrl.text.trim(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () => context.go(AppRoutes.signup),
                      child: const Text("Don't have account? Sign up"),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}