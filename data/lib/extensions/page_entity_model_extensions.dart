import 'package:data/model/entity/page_entity.dart';
import 'package:domain/model/page_model.dart';

extension PageEntityExtension on PageEntity {
  PageModel toModel() => PageModel(
        id: id,
        name: name,
        todoCount: todoCount,
        completionPercent: completionPercent,
      );
}

extension PageModelExtension on PageModel {
  PageEntity toEntity() => PageEntity(
        id: id,
        name: name,
        todoCount: todoCount,
        completionPercent: completionPercent,
      );
}
