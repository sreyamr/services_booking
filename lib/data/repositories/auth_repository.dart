
import '../models/user_model.dart';
import '../services/firebase_auth_service.dart';

class AuthRepository {
  final FirebaseAuthService service;
  AuthRepository(this.service);

  Future<AppUser?> login(String email, String password) async {
    await service.login(email, password);

    return await service.currentUserProfile();
  }

  Future<AppUser?> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await service.signup(email, password);

    final user = AppUser(
      id: cred.user!.uid,
      email: email,
      name: name,
      password: password, role: 'user',
    );

    await service.saveUser(user);
    return user;
  }

  Future<AppUser?> currentUser() => service.currentUserProfile();

  Future<void> logout() => service.logout();
}