import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_provider/models/todo.dart';
import 'package:todo_app_provider/providers/active_todo_count.dart';
import 'package:todo_app_provider/providers/providers.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({Key? key}) : super(key: key);

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
            child: Column(
              children: [
                TodoHeader(),
                CreateTodo(),
                SizedBox(
                  height: 20,
                ),
                SearchAndFilterTodo(),
                ShowTodos(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ShowTodos extends StatelessWidget {
  const ShowTodos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<FilteredTodos>().state.filteredTodos;
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: todos.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: ValueKey(todos[index].id),
          background: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete,
            ),
          ),
          secondaryBackground: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
            ),
          ),
          onDismissed: (direction) => _handleOnDismiss(context, todos[index]),
          confirmDismiss: (_) {
            return showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) {
                  return AlertDialog(
                    title: Text('Are You Sure?'),
                    content: Text('This todo will be deleted permanently.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Delete'),
                      ),
                    ],
                  );
                });
          },
          child: CheckboxListTile(
            onChanged: (bool? value) {
              if (value != null) {
                context.read<TodoList>().toggleTodo(todos[index].id!);
              }
            },
            value: todos[index].completed,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              todos[index].desc,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  decoration: todos[index].completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 4,
        );
      },
    );
  }

  void _handleOnDismiss(BuildContext context, Todo todo) {
    context.read<TodoList>().removeTodo(todo);
  }
}

class SearchAndFilterTodo extends StatelessWidget {
  const SearchAndFilterTodo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Search Todos',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (String? newSearchTerm) {
            if (newSearchTerm != null && newSearchTerm.isNotEmpty) {
              context.read<TodoSearch>().setSearchTerm(newSearchTerm);
            }
          },
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            filterButton(context, Filter.all),
            filterButton(context, Filter.active),
            filterButton(context, Filter.completed),
          ],
        )
      ],
    );
  }

  Widget filterButton(BuildContext context, Filter filter) {
    return TextButton(
      onPressed: () {
        context.read<TodoFilter>().changeFilter(filter);
      },
      child: Text(
        filter.name.toName,
        style: Theme.of(context)
            .textTheme
            .button!
            .copyWith(color: textColor(context, filter)),
      ),
    );
  }

  Color textColor(BuildContext context, Filter filter) {
    final currentFilter = context.watch<TodoFilter>().state.filter;
    return currentFilter == filter ? Colors.blue : Colors.grey;
  }
}

class CreateTodo extends StatefulWidget {
  const CreateTodo({Key? key}) : super(key: key);

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final TextEditingController newTodoController = TextEditingController();

  @override
  void dispose() {
    newTodoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: newTodoController,
      decoration: InputDecoration(labelText: 'What to do?'),
      onSubmitted: (String? todoDesc) {
        if (todoDesc != null && todoDesc.trim().isNotEmpty) {
          context.read<TodoList>().addTodo(todoDesc);
          newTodoController.clear();
        }
      },
    );
  }
}

class TodoHeader extends StatelessWidget {
  const TodoHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'TODO',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          '${context.watch<ActiveTodoCount>().state.activeTodoCount} items left',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: Colors.redAccent),
        )
      ],
    );
  }
}

extension StringUtil on String {
  String get toName {
    return this.replaceRange(0, 1, this[0].toUpperCase());
  }
}
