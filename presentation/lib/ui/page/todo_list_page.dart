import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/extensions/context_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:presentation/gen/assets.gen.dart';
import 'package:presentation/notifier/todo_list_notifier.dart';
import 'package:presentation/temp_ds.dart';
import 'package:presentation/ui/model/page.dart';
import 'package:presentation/ui/widgets/action_button.dart';
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
        child: Stack(
          children: [
            Column(
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
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, right: 32, bottom: 5),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('${(todoNotifier.completeRate * 100).round()}%'),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: todoNotifier.isEditMode ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 100),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Stack(
                      key: ValueKey(todoNotifier.completeRate),
                      children: [
                        Container(
                          width: double.infinity,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Color(0x4DC8C8C8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: todoNotifier.completeRate,
                          child: Container(
                            width: double.infinity,
                            height: 16,
                            decoration: BoxDecoration(
                              color: context.theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // InputItem(
                //   key: ValueKey('투두'),
                //   name: '투두',
                //   onSubmit: todoNotifier.addTodo,
                //   fromPage: false,
                // ),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: ActionButton(
                buttonName: '+ 할일 추가하기',
                onClick: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
