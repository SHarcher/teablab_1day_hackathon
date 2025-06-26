import 'package:uuid/uuid.dart';

enum Priority { high, medium, low }

class Todo {
  final String id;
  final String title;
  final String detail;
  final DateTime dueDate;
  final bool isCompleted;
  final Priority priority;

  Todo({
    String? id,
    required this.title,
    required this.detail,
    required this.dueDate,
    this.isCompleted = false,
    this.priority = Priority.medium,
  }) : id = id ?? const Uuid().v4();

  Todo copyWith({
    String? title,
    String? detail,
    DateTime? dueDate,
    bool? isCompleted,
    Priority? priority,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      detail: detail ?? this.detail,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority, // ✅ 复制优先度
    );
  }
}
