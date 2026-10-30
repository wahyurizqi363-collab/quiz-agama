class AppUser {
  final String uid;
  final String name;
  final String email;
  final String role; // 'student' atau 'admin'

  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
  });

  bool get isAdmin => role == 'admin';

  factory AppUser.fromMap(String uid, Map<String, dynamic> m) => AppUser(
        uid: uid,
        name: (m['name'] as String?) ?? 'Tanpa Nama',
        email: (m['email'] as String?) ?? '',
        role: (m['role'] as String?) ?? 'student',
      );
}
