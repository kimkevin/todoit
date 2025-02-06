import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/extensions/context_extensions.dart';
import 'package:flutter_ds/foundation/color/ds_color_palette.dart';
import 'package:flutter_ds/foundation/typography/ds_text_styles.dart';
import 'package:flutter_ds/ui/widgets/ds_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/gen/assets.gen.dart';
import 'package:presentation/notifier/todo_list_notifier.dart';
import 'package:presentation/ui/model/page.dart';
import 'package:presentation/ui/model/todo.dart';
import 'package:presentation/ui/widgets/todo_list_item.dart';
import 'package:presentation/utils/future_utils.dart';

class TodoListPage extends ConsumerStatefulWidget {
  final PageUiModel page;

  const TodoListPage({super.key, required this.page});

  @override
  ConsumerState<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends ConsumerState<TodoListPage> {
  final ScrollController _scrollController = ScrollController();
  late TextEditingController _pageNameController;
  final List<TextEditingController> _todoNameControllers = [];
  int? newTodoId;

  @override
  void initState() {
    super.initState();

    _pageNameController = TextEditingController(text: widget.page.name);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.watch(todoListProvider).loadTodoList(widget.page.id);
    final result = ref.watch(todoListProvider).todos;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onNewTodoFocused() {
    newTodoId = null;
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    final notifier = ref.watch(todoListProvider);

    ref.listen<List<TodoUiModel>>(todoListProvider.select((state) => state.todos),
        (previous, next) {
      print('previous: $previous');
      print('next: $next');
      if (!listEquals(previous, next)) {
        print('here');
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          GestureDetector(
            onTap: () {
              // notifier.toggleEditMode();
              notifier.clear();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: DsImage(
                notifier.isEditMode ? Assets.svg.icCheck.path : Assets.svg.icEdit.path,
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
                    style: DsTextStyles.headline.copyWith(color: DsColorPalette.gray900),
                    textAlign: TextAlign.left,
                  ),
                ),
                AnimatedOpacity(
                  opacity: notifier.isEditMode ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 100),
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, right: 32, bottom: 5),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text('${(notifier.completeRate * 100).round()}%'),
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: notifier.isEditMode ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 100),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Stack(
                      key: ValueKey(notifier.completeRate),
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
                          widthFactor: notifier.completeRate,
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
                Expanded(
                  child: ReorderableListView(
                    // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    scrollController: _scrollController,
                    onReorder: notifier.reorderTodos,
                    children: [
                      ...notifier.todos.mapIndexed(
                        (index, todo) => TodoListItem(
                          key: ValueKey(todo),
                          reorderIndex: index,
                          controller: TextEditingController(),
                          isEditMode: notifier.isEditMode,
                          actionClick: () {
                            notifier.toggleTodo(todo);
                          },
                          deleteClick: () {
                            notifier.deleteTodo(todo.id);
                          },
                          onTap: () {
                            if (index == notifier.todos.length - 1) {
                              FutureUtils.runDelayed(() {
                                _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                );
                              }, millis: 500);
                            }
                          },
                          onTextChanged: (text) {
                            notifier.addOrUpdateName(index, todo.id, text);
                          },
                          // onNewTodoFocused: onNewTodoFocused,
                          isNew: todo.id == newTodoId,
                          isCompleted: todo.completed == true,
                        ),
                      ),
                      SizedBox(key: ValueKey("bottom_padding"), height: 96),
                    ],
                  ),
                ),
              ],
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: ActionButton(
            //     buttonName: '+ 할일 추가하기',
            //     onClick: () async {
            //       newTodoId = await todoNotifier.addTodo('');
            //       todoNotifier.loadTodoList(widget.page.id);
            //       // FutureUtils.runDelayed(() {
            //       //   _scrollController.animateTo(
            //       //     _scrollController.position.maxScrollExtent,
            //       //     duration: Duration(milliseconds: 300),
            //       //     curve: Curves.easeInOut,
            //       //   );
            //       // });
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
