import 'package:flutter/material.dart';
import 'package:flutter_ds/foundation/color/ds_color_palette.dart';
import 'package:flutter_ds/foundation/typography/ds_text_styles.dart';
import 'package:flutter_ds/ui/widgets/ds_image.dart';
import 'package:flutter_ds/ui/widgets/ds_row.dart';
import 'package:presentation/gen/assets.gen.dart';
import 'package:presentation/ui/model/page.dart';
import 'package:presentation/ui/widgets/dash_divider.dart';

class PageListItem extends StatelessWidget {
  final PageUiModel page;
  final int orderIndex;
  final bool isEditMode;
  final VoidCallback onClick;
  final VoidCallback onDeleteClick;
  final bool hasBottomBorder;

  const PageListItem({
    super.key,
    required this.page,
    required this.orderIndex,
    required this.isEditMode,
    required this.onClick,
    required this.onDeleteClick,
    this.hasBottomBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return DsRow(
      onClick: onClick,
      padding: EdgeInsets.only(left: 32),
      minHeight: 78,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Text(
              page.name,
              style: DsTextStyles.headline,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          if (!isEditMode)
            Padding(
              padding: EdgeInsets.only(left: 12, bottom: 3),
              child: Text(
                page.todoCount.toString(),
                style: DsTextStyles.b3.copyWith(color: DsColorPalette.gray400),
              ),
            )
        ],
      ),
      trailing: Row(
        children: [
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: !isEditMode
                ? SizedBox(width: 32)
                : Row(
                    children: [
                      InkWell(
                        onTap: onDeleteClick,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                          child: DsImage(
                            Assets.svg.icTrash.path,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      ReorderableDragStartListener(
                        index: orderIndex,
                        child: Container(
                          padding: EdgeInsets.only(left: 10, right: 32, top: 10, bottom: 10),
                          child: DsImage(
                            Assets.svg.icDragHandle.path,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
          )
        ],
      ),
      bottomDivider: hasBottomBorder ? DashDivider(horizontalPadding: 32) : SizedBox.shrink(),
    );
    //   GestureDetector(
    //   onTap: onClick,
    //   child: Column(
    //     children: [
    //       Container(
    //         color: Colors.transparent,
    //         padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    //         child: Row(
    //           crossAxisAlignment: CrossAxisAlignment.end,
    //           children: [
    //             Flexible(
    //               child: Text(
    //                 page.name,
    //                 style: DsTextStyles.headline,
    //                 overflow: TextOverflow.ellipsis,
    //                 maxLines: 1,
    //               ),
    //             ),
    //             AnimatedOpacity(
    //               opacity: isEditMode ? 0 : 1,
    //               duration: Duration(milliseconds: 300),
    //               child: SizedBox(width: 12),
    //             ),
    //             AnimatedOpacity(
    //               opacity: isEditMode ? 0 : 1,
    //               duration: Duration(milliseconds: 300),
    //               child: Padding(
    //                 padding: EdgeInsets.only(bottom: 3),
    //                 child: Text(
    //                   page.todoCount.toString(),
    //                   style: DsTextStyles.b3.copyWith(color: DsColorPalette.gray400),
    //                 ),
    //               ),
    //             ),
    //             AnimatedOpacity(
    //               opacity: isEditMode ? 1 : 0,
    //               duration: Duration(milliseconds: 300),
    //               child: Row(
    //                 children: [
    //                   InkWell(
    //                     onTap: onDeleteClick,
    //                     child: Padding(
    //                       padding: EdgeInsets.only(right: 29),
    //                       child: DsImage(
    //                         Assets.svg.icTrash.path,
    //                         width: 24,
    //                         height: 24,
    //                       ),
    //                     ),
    //                   ),
    //                   ReorderableDragStartListener(
    //                     index: orderIndex,
    //                     child: DsImage(
    //                       Assets.svg.icDragHandle.path,
    //                       width: 24,
    //                       height: 24,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //       if (hasBottomBorder) DashDivider(horizontalPadding: 32),
    //     ],
    //   ),
    // );
  }
}
