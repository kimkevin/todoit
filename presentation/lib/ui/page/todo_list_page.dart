import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/notifier/todo_list_page.dart';
import 'package:presentation/ui/model/page.dart';
import 'package:presentation/ui/widgets/todo_input_item.dart';
import 'package:presentation/ui/widgets/todo_list_item.dart';

class TodoListPage extends ConsumerStatefulWidget {
  final PageUiModel page;
  const TodoListPage({super.key, required this.page});

  @override
  ConsumerState<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends ConsumerState<TodoListPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ref.watch(todoListProvider).loadTodoList(widget.page.id);
  }

  @override
  Widget build(BuildContext context) {
    final todoNotifier = ref.watch(todoListProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.page.name),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              InputItem(name: '투두', onSubmit: todoNotifier.addTodo,),
              ...todoNotifier.todos.map(
                (todo) => TodoListItem(
                  todo: todo,
                  onClick: todoNotifier.toggleTodo,
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: 'Create Todo',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
