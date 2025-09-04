import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager_app/models/task_model.dart';

class UserModel {
  String id;
  String name;
  String email;
  DateTime createdAt;

  List<TaskModel>? tasks;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    this.tasks,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: (json['name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Map<String, dynamic> toJsonForCreate() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
