import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  late String title;
  late String description;
  late bool isCompleted;
  late DateTime dueDate;

  Task({
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.dueDate,
  });

  // Create a Task instance from a map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      dueDate: map['dueDate'] != null ? (map['dueDate'] as Timestamp).toDate() : DateTime.now(),
    );
  }

  // Convert Task instance to a map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'dueDate': dueDate,
    };
  }
}
