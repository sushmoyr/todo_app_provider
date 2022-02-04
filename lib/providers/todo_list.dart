import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_provider/models/todo.dart';

class TodoListState extends Equatable {
  final List<Todo> todos;

  TodoListState({
    required this.todos,
  });

  factory TodoListState.initial() {
    return TodoListState(todos: [
      Todo(id: '1', desc: 'Clean the Room'),
      Todo(id: '2', desc: 'Wash the dish'),
      Todo(id: '3', desc: 'Do homework'),
    ]);
  }

  @override
  List<Object?> get props => [todos];

  @override
  bool get stringify => true;

  TodoListState copyWith({
    List<Todo>? todos,
  }) =>
      TodoListState(todos: todos ?? this.todos);
}

class TodoList with ChangeNotifier {
  TodoListState _state = TodoListState.initial();
  TodoListState get state => _state;

  void addTodo(String todoDesc) {
    final newTodo = Todo(desc: todoDesc);
    final newTodos = [..._state.todos, newTodo];

    _state = _state.copyWith(todos: newTodos);
    print(_state.todos);
  }

  void editTodo(String id, String todoDesc) {
    final newTodos = _state.todos.map((Todo todo) {
      if (todo.id == id) {
        return Todo(
          id: id,
          desc: todoDesc,
          completed: todo.completed,
        );
      }

      return todo;
    }).toList();

    _state = _state.copyWith(todos: newTodos);
    notifyListeners();
  }

  void toggleTodo(String id) {
    final newTodo = _state.todos
        .map((e) => (e.id == id)
            ? Todo(id: e.id, desc: e.desc, completed: !e.completed)
            : e)
        .toList();

    _state = _state.copyWith(todos: newTodo);
    notifyListeners();
  }

  void removeTodo(Todo todo) {
    final newTodos =
        _state.todos.where((element) => element.id != todo.id).toList();

    _state = _state.copyWith(todos: newTodos);
    notifyListeners();
  }
}
