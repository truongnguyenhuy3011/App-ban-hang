class User {
  final String idToken;
  final String email;
  final String localId; // Firebase user uid

  User({
    required this.idToken,
    required this.email,
    required this.localId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idToken: json['idToken'],
      email: json['email'],
      localId: json['localId'],
    );
  }
}
