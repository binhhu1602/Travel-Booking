import 'package:flutter/material.dart';
import 'package:travel_booking/core/theme/app_colors.dart';

import '../models/lab_config.dart';
import '../widgets/layout_lab_panel.dart';
import '../widgets/preview_area.dart';

/// Trang chứa khung xem trước và bảng Layout Lab.
class LayoutLabPage extends StatefulWidget {
  const LayoutLabPage({super.key});

  @override
  State<LayoutLabPage> createState() => _LayoutLabPageState();
}

class _LayoutLabPageState extends State<LayoutLabPage> {
  /// Cửa sổ từ mốc này trở lên thì đặt Layout Lab thành cột bên cạnh.
  static const double _sidePanelBreakpoint = 900;

  // Trạng thái nằm ở widget cha chung để cả bảng điều khiển và màn hình xem
  // trước cùng đọc được (kỹ thuật "nâng trạng thái lên").
  LabConfig _config = const LabConfig();

  final ScrollController _previewScroll = ScrollController();

  @override
  void dispose() {
    _previewScroll.dispose();
    super.dispose();
  }

  void _updateConfig(LabConfig next) => setState(() => _config = next);

  @override
  Widget build(BuildContext context) {
    final panel = LayoutLabPanel(config: _config, onChanged: _updateConfig);
    final preview = PreviewArea(config: _config, controller: _previewScroll);

    // LayoutBuilder: đọc chiều rộng thật của cửa sổ để chọn vị trí đặt bảng.
    return LayoutBuilder(
      builder: (context, constraints) {
        final hasSidePanel = constraints.maxWidth >= _sidePanelBreakpoint;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Travel Booking · Layout Lab'),
            scrolledUnderElevation: 0,
            shape: const Border(bottom: BorderSide(color: kBorderGrey)),
            actions: [
              if (!hasSidePanel)
                // Builder: tạo context nằm dưới Scaffold để gọi Scaffold.of().
                Builder(
                  builder: (context) => IconButton(
                    tooltip: 'Mở Layout Lab',
                    icon: const Icon(Icons.tune),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
            ],
          ),
          // Drawer vẫn nằm trong cây của Scaffold nên setState ở trang này cập
          // nhật được bảng điều khiển ngay khi Drawer đang mở.
          endDrawer: hasSidePanel
              ? null
              : Drawer(width: 320, child: SafeArea(child: panel)),
          // Màn che rất nhạt để vẫn nhìn thấy khung xem trước khi chỉnh.
          drawerScrimColor: Colors.black12,
          body: hasSidePanel
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Expanded: khung xem trước lấy toàn bộ phần còn lại.
                    Expanded(child: preview),
                    const VerticalDivider(width: 1),
                    SizedBox(width: 340, child: panel),
                  ],
                )
              : preview,
        );
      },
    );
  }
}
