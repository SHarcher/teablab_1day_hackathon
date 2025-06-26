import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/servises/todo_service.dart';
import 'screen/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutterの初期化
  await initializeDateFormatting('ja_JP', null);
  final prefs = await SharedPreferences.getInstance(); // データ保存の準備
  final todoService = TodoService(prefs); // サービス作成

  runApp(MyApp(todoService: todoService)); // アプリ起動
}

class MyApp extends StatelessWidget {
  final TodoService todoService;

  const MyApp({super.key, required this.todoService});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO アプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: HomeScreen(todoService: todoService),
    );
  }
}
