import 'package:flutter/material.dart';
import 'package:todo/models/todo_filtter.dart';

class TodosFilterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem<TodosFilter>(
            value: TodosFilter.all,
            child: Text("All"),
          ),
          PopupMenuItem<TodosFilter>(
            value: TodosFilter.active,
            child: Text("Active"),
          ),
          PopupMenuItem<TodosFilter>(
            value: TodosFilter.completed,
            child: Text("Completed"),
          ),
        ];
      },
    );
  }
}
