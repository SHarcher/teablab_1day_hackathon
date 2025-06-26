import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/todo.dart';
import '../servises/todo_service.dart'; // <-- 注意路径

class CalendarView extends StatefulWidget {
  final TodoService todoService;

  const CalendarView({super.key, required this.todoService});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await widget.todoService.getTodos();
    setState(() => _todos = todos);
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar<Todo>(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: CalendarFormat.month,
      headerStyle: const HeaderStyle(formatButtonVisible: false),
      eventLoader: (day) {
        return _todos.where((todo) {
          return todo.dueDate.year == day.year &&
              todo.dueDate.month == day.month &&
              todo.dueDate.day == day.day;
        }).toList();
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() => _focusedDay = focusedDay);
        final todosOfTheDay = _todos.where((todo) {
          return todo.dueDate.year == selectedDay.year &&
              todo.dueDate.month == selectedDay.month &&
              todo.dueDate.day == selectedDay.day;
        }).toList();

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(
              "${selectedDay.year}/${selectedDay.month}/${selectedDay.day} のタスク",
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: todosOfTheDay
                  .map(
                    (todo) => ListTile(
                      title: Text(todo.title),
                      subtitle: Text(todo.detail),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
