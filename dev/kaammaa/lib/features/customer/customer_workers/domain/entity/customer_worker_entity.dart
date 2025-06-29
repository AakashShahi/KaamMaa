import 'package:equatable/equatable.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';

class CustomerWorkerEntity extends Equatable {
  final String? id;
  final String username;
  final String? name;
  final String email;
  final CustomerCategoryEntity profession;
  final List<String> skills;
  final String? location;
  final bool isVerified;
  final String? profilePic;
  final String phone;

  const CustomerWorkerEntity({
    required this.id,
    required this.username,
    this.name,
    required this.email,
    required this.profession,
    required this.skills,
    this.location,
    required this.isVerified,
    this.profilePic,
    required this.phone,
  });

  @override
  List<Object?> get props => [
    id,
    username,
    name,
    email,
    profession,
    skills,
    location,
    isVerified,
    profilePic,
    phone,
  ];
}
