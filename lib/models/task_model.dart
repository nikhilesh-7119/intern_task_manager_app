import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime? deadline;
  final DateTime
  createdAt; // used for sorting; overwritten on edit per requirement

  TaskModel({
    required this.id,
    required this.title,
    required this.isCompleted,
    required this.createdAt,
    this.deadline,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? deadline,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory TaskModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final createdField = data['createdAt'];
    final createdAt = createdField is Timestamp
        ? createdField.toDate()
        : DateTime.now();
    return TaskModel(
      id: doc.id,
      title: (data['title'] ?? '') as String,
      isCompleted: (data['isCompleted'] ?? false) as bool,
      deadline: (data['deadline'] is Timestamp)
          ? (data['deadline'] as Timestamp).toDate()
          : null,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMapForCreate() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toMapForUpdateOverwriteCreatedAt() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toMapToggle({required bool newCompleted}) {
    return {
      'isCompleted': newCompleted,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
