import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_provider/providers/todo_list.dart';

class ActiveTodoCountState extends Equatable {
  final int activeTodoCount;

  ActiveTodoCountState({required this.activeTodoCount});

  factory ActiveTodoCountState.initial() =>
      ActiveTodoCountState(activeTodoCount: 0);

  @override
  List<Object> get props => [activeTodoCount];

  @override
  bool get stringify => true;

  ActiveTodoCountState copyWith(int? activeTodoCount) => ActiveTodoCountState(
      activeTodoCount: activeTodoCount ?? this.activeTodoCount);
}

class ActiveTodoCount with ChangeNotifier {
  ActiveTodoCountState _state = ActiveTodoCountState.initial();

  ActiveTodoCountState get state => _state;

  void update(TodoList todoList) {
    final int newActiveTodoCount =
        todoList.state.todos.where((element) => !element.completed).length;

    _state = _state.copyWith(newActiveTodoCount);
    notifyListeners();
  }
}
