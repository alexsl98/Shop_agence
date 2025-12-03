import 'package:shop_agence/src/domain/entity/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.email,
    required super.password,
    required super.address,
    required super.name,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      password: json['password'],
      address: json['address'],
      name: json['name'],
    );
  }
  Map<String, dynamic>toJson(){
    return {
      email: 'email',
      password: 'password',
      address: 'address',
      name: 'name'
    };
  }
}
