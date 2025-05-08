class UserResponse {
  final String message;
  final User user;
  final String token;

  UserResponse({
    required this.message,
    required this.user,
    required this.token,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      message: json['message'] ?? '', // Default to empty string if null
      user: User.fromJson(json['user']),
      token: json['token'] ?? '', // Default to empty string if null
    );
  }
}

class User {
  final int id;
  final String namaLengkap;
  final String email;
  final String emailVerifiedAt;
  final String noWhatsapp;
  final String? fotoProfil; // Handle nullable fields
  final String verifyKey;
  final String role;
  final String createdAt;
  final String updatedAt;

  User({
    required this.id,
    required this.namaLengkap,
    required this.email,
    required this.emailVerifiedAt,
    required this.noWhatsapp,
    this.fotoProfil, // Nullable
    required this.verifyKey,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      namaLengkap: json['nama_lengkap'] ?? 'N/A', // Default value if null
      email: json['email'] ?? 'N/A', // Default value if null
      emailVerifiedAt: json['email_verified_at'] ?? 'N/A', // Default value if null
      noWhatsapp: json['no_whatsapp'] ?? 'N/A', // Default value if null
      fotoProfil: json['foto_profil'], // This can be null
      verifyKey: json['verify_key'] ?? 'N/A', // Default value if null
      role: json['role'] ?? 'user', // Default value if null
      createdAt: json['created_at'] ?? 'N/A', // Default value if null
      updatedAt: json['updated_at'] ?? 'N/A', // Default value if null
    );
  }
}
