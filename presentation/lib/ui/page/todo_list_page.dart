import 'dart:math';

import 'package:animated_digit/animated_digit.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ds/foundation/color/ds_color_palette.dart';
import 'package:flutter_ds/foundation/typography/ds_text_styles.dart';
import 'package:flutter_ds/ui/widgets/ds_appbar_action.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/gen/assets.gen.dart';
import 'package:presentation/notifier/todo_list_notifier.dart';
import 'package:presentation/ui/model/page.dart';
import 'package:presentation/ui/model/todo.dart';
import 'package:presentation/ui/widgets/todo_list_item.dart';
import 'package:presentation/utils/future_utils.dart';
import 'package:presentation/utils/vibration_utils.dart';

class TodoListPage extends ConsumerStatefulWidget {
  final PageUiModel page;

  const TodoListPage({super.key, required this.page});

  @override
  ConsumerState<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends ConsumerState<TodoListPage> {
  final ScrollController _scrollController = ScrollController();
  final List<TodoTextInputState> _todoNameTextInputStates = [];
  final double _unscrollableHeight = 200;
  bool _startAnimation = false;

  // 여기에 퍼센트가 있고 중간중간 업데이트 할 수 있도록 해야할듯... Notifier랑 엮으면 안되는듯

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startDelayedAnimation();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ref.watch(todoListProvider).loadTodoList(widget.page.id);
  }

  @override
  void dispose() {
    for (final state in _todoNameTextInputStates) {
      state.controller.dispose();
      state.focusNode.dispose();
    }
    super.dispose();
  }

  void _startDelayedAnimation() async {
    await Future.delayed(Duration(milliseconds: 200));
    if (mounted) {
      setState(() {
        _startAnimation = true;
      });
    }
  }

  void _addAndSetTodoNameInputState() {
    setState(() {
      _addTodoNameInputState();
      _scrollToBottom();
    });
  }

  void _addTodoNameInputState({String? name}) {
    final inputState = TodoTextInputState(name: name);
    inputState.addListener((focus) {
      if (!focus) {}
    });
    _todoNameTextInputStates.add(inputState);
  }

  void _syncTodoInput(List<TodoUiModel> todos) {
    setState(() {
      for (int i = 0; i < todos.length; i++) {
        if (i <= _todoNameTextInputStates.length - 1) {
          final todoNameTextInputState = _todoNameTextInputStates[i];
          final oldName = todoNameTextInputState.controller.text;
          final newName = todos[i].name;
          if (oldName != newName) {
            todoNameTextInputState.controller.text = newName;
          }
        } else {
          _addTodoNameInputState(name: todos[i].name);
        }
      }

      final lastIndex = _todoNameTextInputStates.length - 1;
      if (todos.isEmpty || todos[lastIndex].name.isNotEmpty || todos[lastIndex].completed) {
        _addTodoNameInputState();
      }
    });
  }

  void _deleteTodo(int index) {
    setState(() {
      _todoNameTextInputStates.removeAt(index);
      ref.watch(todoListProvider).deleteTodo(index);
    });
  }

  void _reorderTodos(int oldIndex, int newIndex) {
    setState(() {
      final lastIndex = _todoNameTextInputStates.length - 1;

      // 마지막 아이템이면 이동 불가 (oldIndex가 마지막 아이템일 경우)
      if (oldIndex == lastIndex) return;

      // 마지막 위치로 이동하려고 하면 마지막 아이템 바로 위로 변경
      if (newIndex >= lastIndex) {
        newIndex = lastIndex;
      }

      // 아이템 이동 로직
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }

      final item = _todoNameTextInputStates.removeAt(oldIndex);
      _todoNameTextInputStates.insert(newIndex, item);

      ref.watch(todoListProvider).reorderTodos(oldIndex, newIndex);
    });
  }

  void _dismissKeyboard() {
    final currentFocus = FocusManager.instance.primaryFocus;
    if (currentFocus != null && currentFocus.hasFocus) {
      currentFocus.unfocus();
    }
  }

  void _scrollToBottom() {
    FutureUtils.runDelayed(() {
      _scrollController.animateTo(
        max(0, _scrollController.position.maxScrollExtent - _unscrollableHeight),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(todoListProvider);

    ref.listen<List<TodoUiModel>>(todoListProvider.select((state) => state.todos),
        (previous, next) {
      if (previous?.isEmpty == true && next.isEmpty || !listEquals(previous, next)) {
        _syncTodoInput(next);
      }
    });

    if (notifier.completeEvent) {
      notifier.finishCompleteEvent();
      triggerStrongVibration();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          DsAppBarAction(
            type: AppBarActionType.image,
            imagePath: notifier.isEditMode ? Assets.svg.icCheck.path : Assets.svg.icEdit.path,
            onTap: () {
              notifier.toggleEditMode();
              _dismissKeyboard();
            },
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
                  padding: EdgeInsets.only(left: 32, right: 32, top: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.page.name,
                        style: DsTextStyles.headline.copyWith(color: DsColorPalette.gray900),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(width: 8),
                      Padding(
                        padding: EdgeInsets.only(bottom: 3),
                        child: Text(
                          '${notifier.completionCount}/${notifier.todoCount}',
                          style: DsTextStyles.b3.copyWith(color: DsColorPalette.gray400),
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedOpacity(
                  opacity: notifier.isEditMode ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 100),
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, right: 32, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedDigitWidget(
                          value: (notifier.completionRate * 100).round(),
                          textStyle: DsTextStyles.b3.copyWith(color: DsColorPalette.gray900),
                        ),
                        Text(
                          '%',
                          style: DsTextStyles.b3.copyWith(color: DsColorPalette.gray900),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedOpacity(
                  opacity: notifier.isEditMode ? 0.0 : 1.0,
                  duration: Duration(milliseconds: 100),
                  child: Padding(
                    padding: EdgeInsets.only(left: 32, right: 34, bottom: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 26,
                            decoration: BoxDecoration(
                              color: DsColorPalette.gray200,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          AnimatedFractionallySizedBox(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            widthFactor: _startAnimation ? notifier.completionRate : 0.0,
                            child: Container(
                              width: double.infinity,
                              height: 26,
                              decoration: BoxDecoration(
                                color: DsColorPalette.gray700,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.black,
                                  width: notifier.completionRate == 0 ? 0 : 2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ReorderableListView(
                    // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    scrollController: _scrollController,
                    onReorder: _reorderTodos,
                    children: [
                      ..._todoNameTextInputStates.mapIndexed(
                        (index, inputState) => TodoListItem(
                          key: ValueKey(index),
                          reorderIndex: index,
                          inputState: inputState,
                          isEditMode: notifier.isEditMode,
                          isCompleted: notifier.getTodo(index)?.completed == true,
                          isLastItem: index == _todoNameTextInputStates.length - 1,
                          actionClick: (completed) {
                            if (index == _todoNameTextInputStates.length - 1) {
                              _addAndSetTodoNameInputState();
                            }
                            notifier.setCompleted(index, completed);
                          },
                          deleteClick: () {
                            _deleteTodo(index);
                          },
                          onClick: () {
                            if (index == notifier.todos.length - 1) {
                              _scrollToBottom();
                            }
                          },
                          onTextChanged: (text) {
                            if (index == _todoNameTextInputStates.length - 1 && text.isNotEmpty) {
                              _addAndSetTodoNameInputState();
                              _scrollToBottom();
                            }
                            notifier.addOrUpdateName(index, text);
                          },
                        ),
                      ),
                      GestureDetector(
                        key: ValueKey('bottom'),
                        behavior: HitTestBehavior.translucent,
                        onTap: _dismissKeyboard,
                        child: SizedBox(
                          width: double.infinity,
                          height: _unscrollableHeight,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
