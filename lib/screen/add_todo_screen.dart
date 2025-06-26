import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../servises/todo_service.dart';

class AddTodoScreen extends StatefulWidget {
  final TodoService todoService;
  final Todo? existingTodo;

  const AddTodoScreen({
    super.key,
    required this.todoService,
    this.existingTodo,
  });

  @override
  AddTodoScreenState createState() => AddTodoScreenState();
}

class AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;
  Priority _selectedPriority = Priority.medium;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();

    if (widget.existingTodo != null) {
      final todo = widget.existingTodo!;
      _titleController.text = todo.title;
      _detailController.text = todo.detail;
      _selectedDate = todo.dueDate;
      _selectedPriority = todo.priority;
      _dateController.text =
          '${todo.dueDate.year}/${todo.dueDate.month}/${todo.dueDate.day}';
    }

    _titleController.addListener(_updateFormValid);
    _detailController.addListener(_updateFormValid);
  }

  void _updateFormValid() {
    setState(() {
      _isFormValid =
          _titleController.text.isNotEmpty &&
          _detailController.text.isNotEmpty &&
          _selectedDate != null;
    });
  }

  Future<void> _saveTodo() async {
    if (_formKey.currentState!.validate()) {
      final newTodo = Todo(
        id: widget.existingTodo?.id ?? UniqueKey().toString(),
        title: _titleController.text,
        detail: _detailController.text,
        dueDate: _selectedDate!,
        isCompleted: widget.existingTodo?.isCompleted ?? false,
        priority: _selectedPriority,
      );

      final todos = await widget.todoService.getTodos();

      if (widget.existingTodo != null) {
        final index = todos.indexWhere((t) => t.id == widget.existingTodo!.id);
        if (index != -1) {
          todos[index] = newTodo;
        }
      } else {
        todos.add(newTodo);
      }

      await widget.todoService.saveTodos(todos);

      if (!mounted) return;
      Navigator.pop(context, newTodo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingTodo != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'タスクを編集' : '新しいタスクを追加'),
        backgroundColor: const Color.fromARGB(255, 201, 169, 212),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'タスクのタイトル',
                  hintText: '20文字以内で入力してください',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'タイトルを入力してください' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _detailController,
                decoration: const InputDecoration(
                  labelText: 'タスクの詳細',
                  hintText: '入力してください',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) =>
                    value == null || value.isEmpty ? '詳細を入力してください' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: '期日',
                  hintText: '年/月/日',
                  border: OutlineInputBorder(),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    _selectedDate = picked;
                    _dateController.text =
                        '${picked.year}/${picked.month}/${picked.day}';
                    _updateFormValid();
                  }
                },
                validator: (value) =>
                    value == null || value.isEmpty ? '期日を選択してください' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Priority>(
                value: _selectedPriority,
                items: const [
                  DropdownMenuItem(value: Priority.high, child: Text('高')),
                  DropdownMenuItem(value: Priority.medium, child: Text('中')),
                  DropdownMenuItem(value: Priority.low, child: Text('低')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedPriority = value;
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: '優先度',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isFormValid ? _saveTodo : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormValid
                      ? const Color.fromARGB(255, 201, 169, 212)
                      : Colors.grey.shade400,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: Text(
                  isEdit ? '更新する' : 'タスクを追加',
                  style: TextStyle(
                    color: _isFormValid ? Colors.white : Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateFormValid();
  }
}
