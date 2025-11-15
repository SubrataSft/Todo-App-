import 'package:flutter/foundation.dart';
import 'db_helper.dart';
import 'model.dart';

class TodoProvider extends ChangeNotifier {
  List<TODOModel> _todoList = [];
  List<TODOModel> get allTODOList => _todoList;

  TodoProvider() {
    loadTodos();
  }

  Future<void> loadTodos() async {
    _todoList = await TodoDB.instance.getAllTodos();
    notifyListeners();
  }

  Future<void> addToDoList(TODOModel todoModel) async {
    await TodoDB.instance.addTodo(todoModel);
    await loadTodos();
  }

  Future<void> removedToDoList(TODOModel todoModel) async {
    if (todoModel.id != null) {
      await TodoDB.instance.deleteTodo(todoModel.id!);
      await loadTodos();
    }
  }

  Future<void> updateToDo(
      TODOModel todo, String newTitle, String newDesc) async {
    final updatedTodo = TODOModel(
      id: todo.id,
      title: newTitle,
      description: newDesc,
      isCompleted: todo.isCompleted,
    );

    await TodoDB.instance.updateTodo(updatedTodo);
    await loadTodos();
  }

  Future<void> todoStatusChange(TODOModel todo) async {
    final updatedTodo = TODOModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      isCompleted: !todo.isCompleted,
    );

    await TodoDB.instance.updateTodo(updatedTodo);
    await loadTodos();
  }
}
