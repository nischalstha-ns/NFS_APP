class UserModel {
  final String uid;
  final String email;
  final String role;
  final String? displayName;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.displayName,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'customer',
      displayName: map['displayName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role,
      'displayName': displayName,
    };
  }

  bool get isAdmin => role == 'admin';
}