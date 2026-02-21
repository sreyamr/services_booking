class AppUser {
  final String id;
  final String email;
  final String name;
  final String password;
  final String role;


  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.password,
    required this.role,
  });

  factory AppUser.fromMap(String id, Map<String, dynamic> map) {
    return AppUser(
      id: id,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? 'user',
    );
  }
  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    String? password,
    String? role,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() => {
    'email': email,
    'name': name,
    'password': password,
  };
}