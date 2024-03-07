class UserModel {
  late String email;
  late String uid;

  UserModel({required this.email, required this.uid});

  factory UserModel.fromMap(Map<String, dynamic> map) =>
      UserModel(email: map['email'] ?? "", uid: map['uid'] ?? "");

  Map<String, dynamic> toMap() => {'email': email, 'uid': uid};
}
