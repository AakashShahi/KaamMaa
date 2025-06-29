import 'dart:io';

import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String username;
  final String email;
  final String? name;
  final String password;
  final String role;
  final String? profession;
  final String? skills;
  final String? location;
  final String? availability;
  final File? certificateUrl;
  final String? isVerified;
  final String phone;

  const AuthEntity({
    this.userId,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    required this.phone,
    this.name,
    this.skills,
    this.availability,
    this.certificateUrl,
    this.isVerified,
    this.profession,
    this.location,
  });

  @override
  List<Object?> get props => [
    userId,
    username,
    email,
    password,
    role,
    phone,
    name,
    skills,
    availability,
    certificateUrl,
    isVerified,
    profession,
    location,
  ];
}
