import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/extensions/context_extensions.dart';
import 'package:flutter_ds/ds_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/gen/assets.gen.dart';
import 'package:presentation/notifier/page_list_notifier.dart';
import 'package:presentation/parser/page_todo_parser.dart';
import 'package:presentation/ui/model/new_page_item_model.dart';
import 'package:presentation/ui/model/new_todo_item_model.dart';
import 'package:presentation/ui/page/new_page.dart';
import 'package:presentation/ui/page/new_parsed_page.dart';
import 'package:presentation/ui/page/todo_list_page.dart';
import 'package:presentation/ui/widgets/page_list_item.dart';
import 'package:presentation/ui/widgets/rounded_text_floating_action_button.dart';
import 'package:presentation/ui/widgets/todo_input_item.dart';
import 'package:presentation/utils/future_utils.dart';

class PageListPage extends ConsumerStatefulWidget {
  const PageListPage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<PageListPage> createState() => _PageListPageState();
}

class _PageListPageState extends ConsumerState<PageListPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 앱 상태 변경 감지 리스너 등록
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 리스너 제거
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      final pageListNotifier = ref.watch(pageListProvider);
      final lastClipboardHash = pageListNotifier.getLastClipboardHash();
      FutureUtils.runDelayed(() {
        checkClipboard(context, lastClipboardHash, (clipboardHash) {
          pageListNotifier.setLastClipboardHash(clipboardHash);
        }, () {
          pageListNotifier.loadPageList();
        });
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ref.watch(pageListProvider).loadPageList();

    final pageListNotifier = ref.watch(pageListProvider);
    final lastClipboardHash = pageListNotifier.getLastClipboardHash();
    FutureUtils.runDelayed(() {
      checkClipboard(context, lastClipboardHash, (clipboardHash) {
        pageListNotifier.setLastClipboardHash(clipboardHash);
      }, () {
        pageListNotifier.loadPageList();
      });
    });
  }

  Future<void> checkClipboard(
    BuildContext context,
    String? lastClipboardHash,
    Function(String) onClipboardHashUpdated,
    VoidCallback onPageChanged,
  ) async {
    ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    String? clipboardText = clipboardData?.text;

    if (clipboardText == null || clipboardText.trim().isEmpty) {
      return;
    }

    String newClipboardHash = md5.convert(utf8.encode(clipboardText)).toString();

    if (!mounted || newClipboardHash == lastClipboardHash) return;

    onClipboardHashUpdated(newClipboardHash);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("클립보드에서 새로운 텍스트 감지: $clipboardText"),
        action: SnackBarAction(
          label: "붙여넣기",
          onPressed: () {
            final result = PageTodoParser().parse(clipboardText);
            List<NewPageItemUiModel> newPageItems = [];
            for (final pageTodo in result.pageTodos) {
              final items =
                  pageTodo.todoNames.map((name) => NewTodoItemUiModel(name: name)).toList();
              newPageItems.add(NewPageItemUiModel(name: pageTodo.pageName, todoItemModels: items));
            }

            context.navigator
                .push(MaterialPageRoute(
                    builder: (context) => NewParsedPage(newPageItems: newPageItems)))
                .then((isUpdated) {
              if (isUpdated is bool && isUpdated == true) {
                onPageChanged();
              }
            });
          },
        ),
        duration: Duration(days: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageNotifier = ref.watch(pageListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                InputItem(
                  name: '페이지',
                  onSubmit: pageNotifier.addPage,
                  fromPage: true,
                ),
                Expanded(
                  child: ReorderableListView(
                    onReorder: pageNotifier.reorderPages,
                    children: [
                      ...pageNotifier.pages.map(
                        (page) => PageListItem(
                          key: ValueKey(page),
                          page: page,
                          onClick: (page) {
                            if (!mounted) return;

                            context.navigator.push(
                                MaterialPageRoute(builder: (context) => TodoListPage(page: page)));
                          },
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
      floatingActionButton: RoundedTextFloatingActionButton(
        icon: DsImage(path: Assets.svg.icPlus.path, width: 24, height: 24),
        onPressed: () {
          context.navigator
              .push(MaterialPageRoute(builder: (context) => NewPage()))
              .then((isUpdated) {
            if (isUpdated == true) {
              pageNotifier.loadPageList();
            }
          });

          // context.navigator
          //     .push(MaterialPageRoute(builder: (context) => NewPage()))
          //     .then((isUpdated) {
          //   if (isUpdated == true) {
          //     pageNotifier.loadPageList();
          //   }
          // });
        },
        text: '새로 만들기',
        // elevation: 20,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   tooltip: 'Create Todo',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
