// home_screen.dart
import 'package:flutter/material.dart';
import 'package:todo/widget/todo_filter_bottom.dart';
import '../servises/todo_service.dart';
import 'list_screen.dart';
import 'calendar_todo_screen.dart';
import 'add_todo_screen.dart';
import '../models/todo.dart';

enum HomeTab { todos, calendar }

class HomeScreen extends StatefulWidget {
  final TodoService todoService;

  const HomeScreen({Key? key, required this.todoService}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeTab _selectedTab = HomeTab.todos;
  final GlobalKey<ListScreenState> _listKey = GlobalKey();

  void _switchTab(HomeTab tab) {
    if (_selectedTab == tab) return;
    setState(() => _selectedTab = tab);
  }

  void _navigateToAddTodoScreen() async {
    final result = await Navigator.push<Todo>(
      context,
      MaterialPageRoute(
        builder: (_) => AddTodoScreen(todoService: widget.todoService),
      ),
    );

    if (result != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('タスクを追加しました')));
      _listKey.currentState?.reloadTodos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO アプリ'),
        backgroundColor: const Color.fromARGB(255, 201, 169, 212),
        actions: [TodosFilterButton()],
      ),
      body: _selectedTab == HomeTab.todos
          ? ListScreen(key: _listKey, todoService: widget.todoService)
          : CalendarView(todoService: widget.todoService),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: _navigateToAddTodoScreen,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.view_list),
              color: _selectedTab == HomeTab.todos ? Colors.grey : Colors.black,
              onPressed: () => _switchTab(HomeTab.todos),
            ),
            const SizedBox(width: 48),
            IconButton(
              icon: const Icon(Icons.calendar_month),
              color: _selectedTab == HomeTab.calendar
                  ? Colors.grey
                  : Colors.black,
              onPressed: () => _switchTab(HomeTab.calendar),
            ),
          ],
        ),
      ),
    );
  }
}
