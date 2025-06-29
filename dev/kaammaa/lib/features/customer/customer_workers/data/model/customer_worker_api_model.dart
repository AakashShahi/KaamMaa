import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaammaa/features/customer/customer_category/data/model/customer_category_api_model.dart';
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
  final List<String> skills;
  @JsonKey(name: 'profession') // THIS FIX
  final CustomerCategoryApiModel category;
  final String? name;
  final bool isVerified;

  const CustomerWorkerApiModel({
    this.workerId,
    required this.username,
    required this.email,
    required this.phone,
    this.profilePic,
    this.location,
    required this.skills,
    required this.category,
    required this.name,
    required this.isVerified,
  });

  factory CustomerWorkerApiModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerWorkerApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerWorkerApiModelToJson(this);

  CustomerWorkerEntity toEntity() {
    return CustomerWorkerEntity(
      id: workerId,
      username: username ?? '',
      email: email ?? '',
      skills: skills,
      isVerified: isVerified,
      phone: phone ?? '',
      profilePic: profilePic,
      location: location,
      name: name,
      profession: category.toEntity(),
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
      skills: entity.skills,
      category: CustomerCategoryApiModel.fromEntity(entity.profession),
      name: entity.name,
      isVerified: entity.isVerified,
    );
  }

  static List<CustomerWorkerEntity> toEntityList(
    List<CustomerWorkerApiModel> models,
  ) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => throw UnimplementedError();
}
