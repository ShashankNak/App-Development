class UserModel {
  final String name;
  final String password;
  final String phoneNumber;
  final String email;
  final String uid;
  UserModel({
    required this.uid,
    required this.name,
    required this.password,
    required this.phoneNumber,
    required this.email,
  });

  //from map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      password: map['password'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
    );
  }

  //to map

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "password": password,
      "phoneNumber": phoneNumber,
      "email": email,
    };
  }
}
