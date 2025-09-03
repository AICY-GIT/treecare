class User {
  final String uid;
  final String fullName;
  final String userName;
  final String email;

  User(
      {required this.uid,
      required this.fullName,
      required this.userName,
      required this.email});

  factory User.fromJson(Map<String, dynamic> json, String uid) {
    return User(
      uid: uid,
      fullName: json['fullName'] ?? '',
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'uid': uid,
      'fullName': fullName,
      'userName': userName,
      'email': email,
    };
  }
}
