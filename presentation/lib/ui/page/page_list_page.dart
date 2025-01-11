import 'package:flutter/material.dart';
import 'package:flutter_core/extensions/context_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/notifier/page_list_notifier.dart';
import 'package:presentation/ui/page/new_page_page.dart';
import 'package:presentation/ui/page/todo_list_page.dart';
import 'package:presentation/ui/widgets/page_list_item.dart';
import 'package:presentation/ui/widgets/todo_input_item.dart';

class PageListPage extends ConsumerStatefulWidget {
  const PageListPage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<PageListPage> createState() => _PageListPageState();
}

class _PageListPageState extends ConsumerState<PageListPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ref.watch(pageListProvider).loadPageList();
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0), // 버튼 주변 패딩
                child: ElevatedButton(
                  onPressed: () {
                    context.navigator.push(
                      MaterialPageRoute(builder: (context) => NewPagePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(64), // 버튼 높이 설정
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // 버튼 모서리 둥글게
                    ),
                  ),
                  child: Text(
                    '+ 새로 만들기',
                    style: TextStyle(fontSize: 18).copyWith(color: Colors.black),
                  ),
                ),
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
