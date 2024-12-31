import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/notifier/home_notifier.dart';
import 'package:presentation/ui/widgets/todo_input_item.dart';
import 'package:presentation/ui/widgets/todo_list_item.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ref.watch(homeProvider).loadTodoList();
  }

  @override
  Widget build(BuildContext context) {
    final todoNotifier = ref.watch(homeProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TodoInputItem(onTodoSubmitted: todoNotifier.addTodo),
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
