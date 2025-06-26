import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/models/todo.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const TodoCard({
    super.key,
    required this.todo,
    this.onToggle,
    this.onDelete,
    this.onTap,
  });

  Color getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return const Color.fromARGB(255, 206, 95, 93);
      case Priority.medium:
        return Colors.yellow.shade300;
      case Priority.low:
        return Colors.green.shade200;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: getPriorityColor(todo.priority),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        child: SizedBox(
          width: double.infinity,
          height: 150,
          child: Row(
            children: [
              IconButton(
                iconSize: 32,
                icon: Icon(
                  todo.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: Colors.black,
                ),
                onPressed: onToggle,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        decoration: todo.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    Text(
                      todo.detail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      DateFormat('M月d日(E)', 'ja').format(todo.dueDate),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.black),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
