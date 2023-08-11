class UserModel {
  String? uid;
  String? email;
  String? username;
  String? type, address, phone;

  UserModel(
      {this.uid,
      this.email,
      this.username,
      this.type,
      this.address,
      this.phone});

  // receive data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      username: map['username'],
      type: map['type'],
      address: map['address'],
      phone: map['phone'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'type': type,
      'address': address,
      'phone': phone,
    };
  }
}
