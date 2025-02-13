import 'package:domain/model/page_model.dart';
import 'package:presentation/ui/model/page.dart';

extension PageDomainExtension on PageModel {
  PageUiModel toUiModel() => PageUiModel(
        id: id,
        name: name,
        todoCount: todoCount,
        completionCount: completionCount,
        completionPercent: completionPercent,
      );
}

extension PageUiExtension on PageUiModel {
  PageModel toModel() => PageModel(
        id: id,
        name: name,
        todoCount: todoCount,
        completionCount: completionCount,
        completionPercent: completionPercent,
      );
}
