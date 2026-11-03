import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:travel_booking/modules/hotel_detail/hotel_detail.dart';

import '../models/lab_config.dart';

/// Khu vực mô phỏng thiết bị: bọc màn hình chi tiết trong SizedBox.
class PreviewArea extends StatelessWidget {
  const PreviewArea({
    super.key,
    required this.config,
    required this.controller,
  });

  final LabConfig config;
  final ScrollController controller;

  String get _deviceName {
    final width = config.previewWidth;
    if (width < 360) return 'Điện thoại nhỏ';
    if (width <= HotelDetailScreen.twoColumnBreakpoint) return 'Điện thoại';
    if (width < 840) return 'Máy tính bảng dọc';
    return 'Máy tính bảng ngang';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const padding = EdgeInsets.fromLTRB(16, 8, 16, 20);

    return ColoredBox(
      color: colors.surfaceContainerLow,
      child: LayoutBuilder(
        builder: (context, viewport) {
          final frameHeight = math.max(
            0.0,
            math.min(viewport.maxHeight - padding.vertical, 820.0),
          );

          // SingleChildScrollView ngang: không giới hạn chiều rộng cho con, nhờ
          // vậy khung 900px vẫn đúng 900px dù cửa sổ thật nhỏ hơn.
          return Scrollbar(
            controller: controller,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              padding: padding,
              child: ConstrainedBox(
                // Khung hẹp hơn cửa sổ thì vẫn được căn giữa.
                constraints: BoxConstraints(
                  minWidth: math.max(0, viewport.maxWidth - padding.horizontal),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  // SizedBox: ép cứng kích thước để mô phỏng từng loại thiết bị.
                  child: SizedBox(
                    width: config.previewWidth,
                    height: frameHeight,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 28,
                          child: Text(
                            '${config.previewWidth.round()} px · $_deviceName · '
                            '${config.isTwoColumn ? '2 cột' : '1 cột'}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: HotelDetailScreen(
                              options: config.hotelOptions,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
