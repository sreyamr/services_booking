import 'package:flutter/cupertino.dart';
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

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();


  bool isFormValid = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSignupSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signup successful!')),
                );

                Future.delayed(const Duration(milliseconds: 300), () {
                  context.go(AppRoutes.login);
                });
              }

              if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Text('Create account', style: AppTextStyles.title),
                    const SizedBox(height: 4),
                    Text('Sign up to get started!', style: AppTextStyles.body),

                    const SizedBox(height: 24),
                    AppTextField(
                      controller: nameCtrl,
                      hint: 'Full name',
                      icon: Icons.person_outline,
                      validator: SignupValidator.name,
                    ),

                    const SizedBox(height: 14),
                    AppTextField(
                      controller: emailCtrl,
                      hint: 'Email address',
                      icon: Icons.email_outlined,
                      validator: SignupValidator.email,
                    ),

                    const SizedBox(height: 14),
                    AppTextField(
                      controller: passCtrl,
                      hint: 'Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      validator: SignupValidator.password,
                    ),

                    const SizedBox(height: 14),
                    AppTextField(
                      controller: confirmCtrl,
                      hint: 'Confirm password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      validator: (v) =>
                          SignupValidator.confirmPassword(v, passCtrl.text),
                    ),

                    const SizedBox(height: 40),
                    AppButton(
                      text: 'Sign up',
                      loading: state is AuthLoading,
                      onTap: state is AuthLoading
                          ? null
                          : () {
                        FocusScope.of(context).unfocus();

                        // final isValid = _formKey.currentState!.validate();
                        // if (!isValid) return;

                        context.read<AuthBloc>().add(
                          SignupRequested(
                            nameCtrl.text.trim(),
                            emailCtrl.text.trim(),
                            passCtrl.text.trim(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () => context.go(AppRoutes.login),
                        child: const Text('Already member? Log in'),
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