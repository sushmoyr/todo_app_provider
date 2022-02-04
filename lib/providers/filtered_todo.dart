import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_provider/models/todo.dart';
import 'package:todo_app_provider/providers/todo_filter.dart';
import 'package:todo_app_provider/providers/todo_list.dart';
import 'package:todo_app_provider/providers/todo_search.dart';

class FilteredTodosState extends Equatable {
  final List<Todo> filteredTodos;

  FilteredTodosState({required this.filteredTodos});

  factory FilteredTodosState.initial() => FilteredTodosState(filteredTodos: []);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [filteredTodos];

  FilteredTodosState copyWith(List<Todo>? filteredTodos) =>
      FilteredTodosState(filteredTodos: filteredTodos ?? this.filteredTodos);
}

class FilteredTodos with ChangeNotifier {
  FilteredTodosState _state = FilteredTodosState.initial();

  FilteredTodosState get state => _state;

  void update(
    TodoFilter todoFilter,
    TodoSearch todoSearch,
    TodoList todoList,
  ) {
    List<Todo> _filteredTodos;

    switch (todoFilter.state.filter) {
      case Filter.active:
        _filteredTodos = todoList.state.todos
            .where((element) => !element.completed)
            .toList();
        break;
      case Filter.completed:
        _filteredTodos =
            todoList.state.todos.where((element) => element.completed).toList();
        break;
      case Filter.all:
      default:
        _filteredTodos = todoList.state.todos;
        break;
    }

    if (todoSearch.state.searchTerm.isNotEmpty) {
      _filteredTodos = _filteredTodos
          .where((element) =>
              element.desc.toLowerCase().contains(todoSearch.state.searchTerm))
          .toList();
    }

    _state = _state.copyWith(_filteredTodos);
    notifyListeners();
  }
}
