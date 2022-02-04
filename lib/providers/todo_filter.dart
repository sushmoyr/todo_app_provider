import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_app_provider/models/todo.dart';

class TodoFilterState extends Equatable {
  final Filter filter;

  TodoFilterState({required this.filter});

  factory TodoFilterState.initial() => TodoFilterState(filter: Filter.all);

  @override
  // TODO: implement props
  List<Object?> get props => [filter];

  @override
  bool get stringify => true;

  TodoFilterState copyWith({Filter? filter}) =>
      TodoFilterState(filter: filter ?? this.filter);
}

class TodoFilter with ChangeNotifier {
  TodoFilterState _state = TodoFilterState.initial();

  TodoFilterState get state => _state;

  void changeFilter(Filter newFilter) {
    _state = _state.copyWith(filter: newFilter);
    notifyListeners();
  }
}
