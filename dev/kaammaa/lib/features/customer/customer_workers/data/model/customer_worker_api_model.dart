import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaammaa/features/customer/customer_category/data/model/customer_category_api_model.dart';
import 'package:kaammaa/features/customer/customer_category/domain/entity/customer_category_entity.dart';
import 'package:kaammaa/features/customer/customer_workers/domain/entity/customer_worker_entity.dart';

part 'customer_worker_api_model.g.dart';

@JsonSerializable()
class CustomerWorkerApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? workerId;
  final String? username;
  final String? email;
  final String? phone;
  final String? profilePic;
  final String? location;
  final List<String>? skills;
  @JsonKey(name: 'profession')
  final CustomerCategoryApiModel? category;
  final String? name;
  final bool? isVerified;

  const CustomerWorkerApiModel({
    this.workerId,
    this.username,
    this.email,
    this.phone,
    this.profilePic,
    this.location,
    this.skills,
    this.category,
    this.name,
    this.isVerified,
  });

  factory CustomerWorkerApiModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerWorkerApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerWorkerApiModelToJson(this);

  CustomerWorkerEntity toEntity() {
    return CustomerWorkerEntity(
      id: workerId,
      username: username ?? '',
      email: email ?? '',
      phone: phone ?? '',
      profilePic: profilePic,
      location: location,
      name: name,
      isVerified: isVerified ?? false,
      skills: skills ?? [],
      profession: category?.toEntity() ?? const CustomerCategoryEntity.empty(),
    );
  }

  static CustomerWorkerApiModel fromEntity(CustomerWorkerEntity entity) {
    return CustomerWorkerApiModel(
      workerId: entity.id,
      username: entity.username,
      email: entity.email,
      phone: entity.phone,
      profilePic: entity.profilePic,
      location: entity.location,
      name: entity.name,
      isVerified: entity.isVerified,
      skills: entity.skills,
      category: CustomerCategoryApiModel.fromEntity(entity.profession),
    );
  }

  static List<CustomerWorkerEntity> toEntityList(
    List<CustomerWorkerApiModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [
    workerId,
    username,
    email,
    phone,
    profilePic,
    location,
    skills,
    category,
    name,
    isVerified,
  ];
}
