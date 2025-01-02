import 'package:domain/model/page_model.dart';
import 'package:presentation/ui/model/page.dart';

extension PageDomainExtension on PageModel {
  PageUiModel toUiModel() => PageUiModel(
        id: id,
        name: name,
      );
}

extension PageUiExtension on PageUiModel {
  PageModel toModel() => PageModel(
        id: id,
        name: name,
      );
}
