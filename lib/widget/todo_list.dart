import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../servises/todo_service.dart';
import 'package:todo/widget/todo_card.dart';
import 'package:todo/screen/add_todo_screen.dart';

class TodoList extends StatefulWidget {
  final TodoService todoService;

  const TodoList({super.key, required this.todoService});

  @override
  State<TodoList> createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  List<Todo> _todos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    try {
      final todos = await widget.todoService.getTodos();
      setState(() {
        _todos = todos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('読み込みに失敗しました: $e')));
    }
  }

  Future<void> _toggleTodo(Todo todo, bool value) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      setState(() {
        _todos[index] = todo.copyWith(isCompleted: value);
      });
      await widget.todoService.saveTodos(_todos);
    }
  }

  Future<void> _deleteTodo(Todo todo) async {
    setState(() => _todos.removeWhere((t) => t.id == todo.id));
    await widget.todoService.saveTodos(_todos);
  }

  Future<void> _editTodo(Todo todo) async {
    final updated = await Navigator.push<Todo?>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AddTodoScreen(todoService: widget.todoService, existingTodo: todo),
      ),
    );

    if (updated != null) {
      final index = _todos.indexWhere((t) => t.id == updated.id);
      if (index != -1) {
        setState(() {
          _todos[index] = updated;
        });
        await widget.todoService.saveTodos(_todos);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_todos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.task_alt, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'まだタスクがありません',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              '「+」ボタンから\n新しいタスクを追加してみましょう！',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _todos.length,
      itemBuilder: (context, index) {
        final todo = _todos[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: TodoCard(
            todo: todo,
            onToggle: () => _toggleTodo(todo, !todo.isCompleted),
            onDelete: () => _deleteTodo(todo),
            onTap: () => _editTodo(todo),
          ),
        );
      },
    );
  }
}
