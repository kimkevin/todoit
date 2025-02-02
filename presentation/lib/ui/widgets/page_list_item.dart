import 'package:flutter/material.dart';
import 'package:flutter_ds/foundation/color/ds_color_palete.dart';
import 'package:flutter_ds/foundation/typography/ds_text_styles.dart';
import 'package:flutter_ds/ui/widgets/ds_image.dart';
import 'package:presentation/gen/assets.gen.dart';
import 'package:presentation/ui/model/page.dart';

class PageListItem extends StatelessWidget {
  final PageUiModel page;
  final int orderIndex;
  final bool isEditMode;
  final VoidCallback onClick;
  final VoidCallback onDeleteClick;

  const PageListItem({
    super.key,
    required this.page,
    required this.orderIndex,
    required this.isEditMode,
    required this.onClick,
    required this.onDeleteClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    page.name,
                    style: DsTextStyles.headline,
                  ),
                  AnimatedOpacity(
                    opacity: isEditMode ? 0 : 1,
                    duration: Duration(milliseconds: 300),
                    child: SizedBox(width: 12),
                  ),
                  AnimatedOpacity(
                    opacity: isEditMode ? 0 : 1,
                    duration: Duration(milliseconds: 300),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 3),
                      child: Text(
                        page.todoCount.toString(),
                        style: DsTextStyles.b3.copyWith(color: DsColorPalette.gray400),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: isEditMode ? 1 : 0,
              duration: Duration(milliseconds: 300),
              child: Row(
                children: [
                  InkWell(
                    onTap: onDeleteClick,
                    child: Padding(
                      padding: EdgeInsets.only(right: 29),
                      child: DsImage(
                        Assets.svg.icTrash.path,
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  ReorderableDragStartListener(
                    index: orderIndex,
                    child: DsImage(
                      Assets.svg.icDragHandle.path,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
