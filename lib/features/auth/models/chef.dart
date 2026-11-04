/// The authenticated chef (canteen head cook), as returned by `/login`.
class Chef {
  const Chef({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.chefCode,
    this.schoolId,
  });

  final String id;
  final String name;
  final String email;
  final String role;

  /// The `user_id` the chef types on the login screen, e.g. `CHEF-1234`.
  final String? chefCode;
  final String? schoolId;

  factory Chef.fromJson(Map<String, dynamic> json) {
    return Chef(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      chefCode: json['user_id']?.toString(),
      schoolId: json['school_id']?.toString(),
    );
  }

  Map<String, String> toStorageMap() => {
        AuthStorageKeys.chefId: id,
        AuthStorageKeys.chefName: name,
        AuthStorageKeys.chefEmail: email,
        AuthStorageKeys.chefRole: role,
        AuthStorageKeys.chefCode: chefCode ?? '',
        AuthStorageKeys.schoolId: schoolId ?? '',
      };
}

/// Keys used for the locally persisted session.
class AuthStorageKeys {
  AuthStorageKeys._();

  static const String accessToken = 'chef_access_token';
  static const String refreshToken = 'chef_refresh_token';
  static const String chefId = 'chef_id';
  static const String chefName = 'chef_name';
  static const String chefEmail = 'chef_email';
  static const String chefRole = 'chef_role';
  static const String chefCode = 'chef_code';
  static const String schoolId = 'chef_school_id';

  static const List<String> all = [
    accessToken,
    refreshToken,
    chefId,
    chefName,
    chefEmail,
    chefRole,
    chefCode,
    schoolId,
  ];
}
