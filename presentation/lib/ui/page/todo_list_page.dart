import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:presentation/gen/assets.gen.dart';
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
        actions: [
          GestureDetector(
            onTap: () {
              todoNotifier.toggleEditMode();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SvgPicture.asset(
                todoNotifier.isEditMode ? Assets.svg.icCheck.path : Assets.svg.icEdit.path,
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
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
            AnimatedOpacity(
              opacity: todoNotifier.isEditMode ? 0.0 : 1.0,
              duration: Duration(milliseconds: 100),
              child: Stack(
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
            ),
            InputItem(
              key: ValueKey('투두'),
              name: '투두',
              onSubmit: todoNotifier.addTodo,
              fromPage: false,
            ),
            Expanded(
              child: ReorderableListView(
                onReorder: todoNotifier.reorderTodos,
                children: [
                  ...todoNotifier.todos.mapIndexed(
                    (index, todo) => TodoListItem(
                      key: ValueKey(todo),
                      reorderIndex: index,
                      todo: todo,
                      isEditMode: todoNotifier.isEditMode,
                      actionClick: todoNotifier.toggleTodo,
                      deleteClick: todoNotifier.deleteTodo,
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
