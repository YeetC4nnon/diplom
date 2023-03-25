// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';

var isUser = FirebaseAuth.instance.currentUser?.uid;

class Studio {
  late String title;
  var min_cost;
  late String address;
  late String description;
  var id;

  Studio({
    required this.title,
    required this.min_cost,
    required this.address,
    this.description = '',
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'min_cost': min_cost,
        'address': address,
        'description': description,
        'id': id,
      };

  static Studio fromJson(Map<String, dynamic> json) => Studio(
        title: json['title'],
        min_cost: json['min_cost'],
        address: json['address'],
        description: json['description'],
        id: json['id'],
      );
}

class thisUser {
  late String name;
  late String email;
  late String password;
  var id;

  thisUser({
    required this.email,
    required this.password,
    required this.name,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'id': id,
      };

  static thisUser fromJson(Map<String, dynamic> json) => thisUser(
        name: json['name'],
        email: json['email'],
        password: json['password'],
        id: json['id'],
      );
}

class Record {
  var studio_id;
  var sum;
  var user_id;
  late String studio_title;
  late String user_email;
  late String user_name;

  Record({
    required this.studio_id,
    required this.sum,
    required this.user_id,
    required this.studio_title,
    required this.user_email,
    required this.user_name,
  });

  Map<String, dynamic> toJson() => {
        'studio_id': studio_id,
        'sum': sum,
        'user_id': user_id,
        'studio_title': studio_title,
        'user_email': user_email,
        'user_name': user_name,
      };

  static Record fromJson(Map<String, dynamic> json) => Record(
        studio_id: json['studio_id'],
        sum: json['sum'],
        user_id: json['user_id'],
        studio_title: json['studio_title'],
        user_email: json['user_email'],
        user_name: json['user_name'],
      );
}
