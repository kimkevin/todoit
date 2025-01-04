import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/notifier/todo_list_notifier.dart';
import 'package:presentation/temp_ds.dart';
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
        // title: Text(widget.page.name),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              key: ValueKey(widget.page.name),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              alignment: Alignment.centerLeft,
              child: Text(
                widget.page.name,
                style: DsTextStyles.title,
                textAlign: TextAlign.left,
              ),
            ),
            Stack(
              key: ValueKey(todoNotifier.completeRate),
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 3.5, bottom: 8.5),
                  child: Divider(
                    thickness: 8,
                    color: Color(0x9E9FA080),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3.5, bottom: 8.5),
                  child: FractionallySizedBox(
                    widthFactor: todoNotifier.completeRate,
                    child: Divider(thickness: 8, color: Color(0xFF008DFF)),
                  ),
                ),
              ],
            ),
            InputItem(
              key: ValueKey('투두'),
              name: '투두',
              onSubmit: todoNotifier.addTodo,
              fromPage: false,
            ),
            Expanded(
              child: ReorderableListView(
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    // 타이틀의 순서를 변경하지 않도록 설정
                    // if (oldIndex == 0 || newIndex == 0) return;

                    // if (newIndex > oldIndex) newIndex -= 1;
                    // final item = items.removeAt(oldIndex - 1);
                    // items.insert(newIndex - 1, item);

                    todoNotifier.reorderTodos(oldIndex, newIndex);
                  });
                },
                children: [
                  ...todoNotifier.todos.map(
                    (todo) => TodoListItem(
                      key: ValueKey(todo),
                      todo: todo,
                      onClick: todoNotifier.toggleTodo,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
