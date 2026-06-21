import '../../domain/entities/user.dart';

class UserModel {
  const UserModel({
    required this.username,
    required this.email,
    required this.isAdmin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      isAdmin: json['isAdmin'] == true,
    );
  }

  final String username;
  final String email;
  final bool isAdmin;

  User toEntity() => User(
        username: username,
        email: email,
        isAdmin: isAdmin,
      );
}
