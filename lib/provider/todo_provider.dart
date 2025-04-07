import 'package:flutter/material.dart';
import 'package:todo_app/model/todo_model.dart';

class TodoProvider with ChangeNotifier {
  final List<TodoModel> _todo = [];
  List<TodoModel> get todo => _todo;

  int get totalTodo => _todo.length;
  int get completedTodo => _todo.where((todo) => todo.isCompleted).length;

  double get completedPercentage {
    if (totalTodo == 0) return 0;
    return (completedTodo / totalTodo) * 100;
  }

  void addTodo(String title) {
    final newTodo = TodoModel(id: DateTime.now().toString(), title: title);
    _todo.add(newTodo);
    notifyListeners();
  }

  void toggleTodo(String id) {
    final index = _todo.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todo[index].isCompleted = !_todo[index].isCompleted;
      notifyListeners();
    }
  }

  void resetTodo() {
    for (var todo in _todo) {
      todo.isCompleted = false;
    }
    notifyListeners();
  }

  void removeTodo(String id) {
    _todo.removeWhere((tx) => tx.id == id);
    notifyListeners();
  }
}
