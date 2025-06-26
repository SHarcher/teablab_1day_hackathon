import 'package:flutter/material.dart';
import '../servises/todo_service.dart';
import '../widget/todo_list.dart';

class ListScreen extends StatefulWidget {
  final TodoService todoService;

  const ListScreen({super.key, required this.todoService});

  @override
  ListScreenState createState() => ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  Key _listKey = UniqueKey(); // 用于强制 TodoList 重建

  // 外部可以调用此方法刷新 TodoList（比如添加任务后）
  void reloadTodos() {
    setState(() {
      _listKey = UniqueKey(); // 重新生成 key → 触发 TodoList 重建
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TodoList(key: _listKey, todoService: widget.todoService),
    );
  }
}
