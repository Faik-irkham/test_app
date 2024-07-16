class UserModel {
  final String? token;
  final String? name;
  final String? email;
  final String? password;

  UserModel({
    this.token,
    this.name,
    this.email,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return UserModel(
      token: json['token'],
      name: data['name'],
      email: data['email'],
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'name': name,
        'email': email,
        'password': password,
      };

  UserModel copyWith({
    String? name,
    String? email,
    String? password,
  }) =>
      UserModel(
        token: token,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
      );
}
