import 'package:flutter/material.dart';
import 'package:flutter_ds/ds_image.dart';
import 'package:presentation/gen/assets.gen.dart';
import 'package:presentation/temp_ds.dart';
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
                children: [
                  Text(
                    page.name,
                    style: DsTextStyles.item,
                  ),
                  SizedBox(width: 12),
                  Text(
                    page.todoCount.toString(),
                    style: DsTextStyles.pageInfo.copyWith(color: Color(0xFF9E9FA0)),
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
