import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/extensions/context_extensions.dart';
import 'package:flutter_ds/foundation/color/ds_color_palette.dart';
import 'package:flutter_ds/foundation/typography/ds_text_styles.dart';
import 'package:flutter_ds/ui/widgets/ds_appbar_action.dart';
import 'package:flutter_ds/ui/widgets/ds_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/gen/assets.gen.dart';
import 'package:presentation/notifier/page_list_notifier.dart';
import 'package:presentation/parser/page_todo_parser.dart';
import 'package:presentation/ui/model/new_page_item_model.dart';
import 'package:presentation/ui/model/page.dart';
import 'package:presentation/ui/page/new_page.dart';
import 'package:presentation/ui/page/new_parsed_page.dart';
import 'package:presentation/ui/page/todo_list_page.dart';
import 'package:presentation/ui/widgets/page_list_item.dart';
import 'package:presentation/utils/future_utils.dart';
import 'package:presentation/utils/localization_utils.dart';

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
    if (!mounted) return;

    ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    String? clipboardText = clipboardData?.text;

    if (clipboardText == null || clipboardText.trim().isEmpty) {
      return;
    }

    String newClipboardHash = md5.convert(utf8.encode(clipboardText)).toString();

    if (!mounted || newClipboardHash == lastClipboardHash) return;

    final result = PageTodoParser().parse(
      clipboardText,
      LocalizationUtils.getDefaultName(context),
    );
    if (result == null) return;

    onClipboardHashUpdated(newClipboardHash);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("클립보드에서 새로운 텍스트 감지\n$clipboardText"),
        action: SnackBarAction(
          label: "붙여넣기",
          onPressed: () {
            List<NewPageItemUiModel> newPageItems = [];
            for (final pageTodo in result.pageTodos) {
              newPageItems
                  .add(NewPageItemUiModel(name: pageTodo.pageName, todoNames: pageTodo.todoNames));
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

  void onPageClick(PageUiModel page) {
    if (!mounted) return;

    context.navigator.push(MaterialPageRoute(builder: (context) => TodoListPage(page: page))).then(
      (_) {
        ref.watch(pageListProvider).loadPageList();
      },
    );
  }

  void onNewPageClick(PageListNotifier notifier) {
    if (!mounted) return;

    context.navigator.push(MaterialPageRoute(builder: (context) => NewPage())).then(
      (isUpdated) {
        if (isUpdated is bool && isUpdated) {
          notifier.loadPageList();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(pageListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          DsAppBarAction(
            type: AppBarActionType.image,
            imagePath: notifier.isEditMode ? Assets.svg.icCheck.path : Assets.svg.icEdit.path,
            onTap: notifier.toggleEditMode,
          ),
        ],
      ),
      body: SafeArea(
        child: ReorderableListView(
          onReorder: notifier.reorderPages,
          children: [
            ...notifier.pages.mapIndexed(
              (index, page) => PageListItem(
                key: ValueKey(page),
                page: page,
                orderIndex: index,
                isEditMode: notifier.isEditMode,
                hasBottomBorder: index != notifier.pages.length - 1,
                onDeleteClick: () {
                  notifier.deletePage(page.id);
                },
                onClick: () {
                  onPageClick(page);
                },
                onTextChanged: (text) {
                  notifier.updateName(page.id, text);
                },
              ),
            ),
            SizedBox(key: ValueKey("bottom_padding"), height: 96),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: !notifier.isEditMode,
        child: GestureDetector(
          onTap: () {
            onNewPageClick(notifier);
          },
          child: Container(
            padding: EdgeInsets.only(top: 16, bottom: 16, left: 16, right: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              shape: BoxShape.rectangle,
              color: DsColorPalette.gray700,
              border: Border.all(
                color: DsColorPalette.black,
                width: 2.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DsImage(
                  Assets.svg.icPlus.path,
                  width: 24,
                  height: 24,
                  color: DsColorPalette.white,
                ),
                const SizedBox(width: 10.0),
                Text(
                  '새로 만들기',
                  style: DsTextStyles.b2.copyWith(color: DsColorPalette.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
