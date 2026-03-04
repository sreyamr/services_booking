import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../../data/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;

  AuthBloc(this.repo) : super(AuthInitial()) {
    on<CheckSession>(_onCheckSession);
    on<LoginRequested>(_onLogin);
    on<SignupRequested>(_onSignup);
    on<LogoutRequested>(_onLogout);
  }

  Future<void> _onCheckSession(CheckSession e, Emitter<AuthState> emit) async {
    try {
      final user = await repo.currentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogin(LoginRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await repo.login(e.email, e.password);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthFailure("Login failed. Please try again."));
      }
    } on FirebaseAuthException catch (ex) {

      String message;
      switch (ex.code) {
        case 'invalid-email':
          message = "The email address is invalid.";
          break;
        case 'user-disabled':
          message = "This account has been disabled.";
          break;
        case 'user-not-found':
          message = "No account found with this email.";
          break;
        case 'wrong-password':
          message = "Incorrect password. Please try again.";
          break;
        case 'too-many-requests':
          message = "Too many attempts. Please try again later.";
          break;
        default:
          message = "Authentication failed. Please try again.";
      }
      emit(AuthFailure(message));
    } catch (e) {
      emit(AuthFailure("Something went wrong. Please try again."));
    }
  }

  Future<void> _onSignup(SignupRequested e, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await repo.signup(
        name: e.name,
        email: e.email,
        password: e.password,
      );

      emit(AuthSignupSuccess());

    } on FirebaseAuthException catch (ex) {
      String message;
      switch (ex.code) {
        case 'email-already-in-use':
          message = "This email is already registered.";
          break;
        case 'invalid-email':
          message = "The email address is invalid.";
          break;
        case 'weak-password':
          message = "Password is too weak. Try a stronger one.";
          break;
        default:
          message = "Signup failed. Please try again.";
      }
      emit(AuthFailure(message));
    } catch (e) {
      emit(AuthFailure("Something went wrong. Please try again."));
    }
  }

  Future<void> _onLogout(LogoutRequested e, Emitter<AuthState> emit) async {
    await repo.logout();
    emit(AuthUnauthenticated());
  }
}
