class UserModel {
  final String email;
  final String password;
  String uid;

  

  UserModel({
    required this.email,
    required this.password,
    required this.uid,

  });

  set setUid(value) => uid = value;
  
  get getPassword => password;

  Map<String, dynamic> toJson() => {
    'uid' : uid,
    'email' : email,
    'pwd' : password,
  };
}
