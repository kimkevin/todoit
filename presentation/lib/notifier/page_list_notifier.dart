import 'dart:collection';

import 'package:di/injection_container.dart';
import 'package:domain/repository/page_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presentation/extensions/page_domain_ui_extensions.dart';
import 'package:presentation/ui/model/page.dart';

class PageListNotifier with ChangeNotifier {
  final PageRepository pageRepository;

  List<PageUiModel> _pages = <PageUiModel>[];
  List<PageUiModel> get pages => UnmodifiableListView(_pages);

  PageListNotifier({required this.pageRepository});

  void loadPageList() async {
    _pages = (await pageRepository.getAllPages()).map((e) => e.toUiModel()).toList();
    print('_pages= $_pages');
    notifyListeners();
  }

  void addPage(String name) async {
    await pageRepository.createPage(name);
    loadPageList();
  }

  void reorderPages(int oldIndex, int newIndex) async {
    // UI 먼저 보여줌
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = _pages.removeAt(oldIndex);
    _pages.insert(newIndex, item);
    notifyListeners();

    await pageRepository.reorderTodos(oldIndex, newIndex);
    loadPageList();
  }
}

// Finally, we are using ChangeNotifierProvider to allow the UI to interact with our TodosNotifier class.
final pageListProvider = ChangeNotifierProvider<PageListNotifier>(
  (ref) => PageListNotifier(pageRepository: getIt<PageRepository>()),
);
