// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

var isUser = FirebaseAuth.instance.currentUser?.uid;

@JsonSerializable()
class Studio {
  late String title;
  int min_cost;
  late String address;
  late String description;
  int studio_id;
  double factor;
  late String login;
  late String password;

  Studio({
    required this.title,
    required this.min_cost,
    required this.address,
    this.description = '',
    required this.studio_id,
    required this.factor,
    this.login = '',
    this.password = '',
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'min_cost': min_cost,
        'address': address,
        'description': description,
        'studio_id': studio_id,
        'factor': factor,
        'login': login,
        'password': password,
      };

  static Studio fromJson(Map<String, dynamic> json) => Studio(
        title: json['title'],
        min_cost: json['min_cost'],
        address: json['address'],
        description: json['description'],
        studio_id: json['studio_id'],
        factor: json['factor'],
        login: json['login'],
        password: json['password'],
      );
}

@JsonSerializable()
class thisUser {
  late String name;
  late String email;
  late String password;
  String id;

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

@JsonSerializable()
class Record {
  int studio_id;
  double sum;
  String user_id;
  late String studio_title;
  late String user_email;
  late String user_name;
  late String tariff_title;
  late String tariff_type;
  late String datetime;
  late String login;

  Record({
    required this.studio_id,
    required this.sum,
    required this.user_id,
    required this.studio_title,
    required this.user_email,
    required this.user_name,
    required this.tariff_title,
    required this.tariff_type,
    required this.datetime,
    required this.login,
  });

  Map<String, dynamic> toJson() => {
        'studio_id': studio_id,
        'sum': sum,
        'user_id': user_id,
        'studio_title': studio_title,
        'user_email': user_email,
        'user_name': user_name,
        'tariff_title': tariff_title,
        'tariff_type': tariff_type,
        'datetime': datetime,
        'login': login,
      };

  static Record fromJson(Map<String, dynamic> json) => Record(
        studio_id: json['studio_id'],
        sum: json['sum'],
        user_id: json['user_id'],
        studio_title: json['studio_title'],
        user_email: json['user_email'],
        user_name: json['user_name'],
        tariff_title: json['tariff_title'],
        tariff_type: json['tariff_type'],
        datetime: json['datetime'],
        login: json['login'],
      );
}
