enum UserRole { member, admin }

Map<UserRole, String> userRole = {
  UserRole.member: 'member',
  UserRole.admin: 'admin',
};

class UserModel {
  String username;
  String email;
  String password;
  String cPassword;
  String image;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
    required this.cPassword,
    required this.image,
  });
}
