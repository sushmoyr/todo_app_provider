import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

class Todo {
  final String? id;
  final String desc;
  final bool completed;

  Todo({
    String? id,
    required this.desc,
    this.completed = false,
  }) : id = id ?? uuid.v4();
}

enum Filter {
  all,
  active,
  completed,
}
