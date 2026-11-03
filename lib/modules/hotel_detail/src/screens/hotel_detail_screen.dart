import 'package:flutter/material.dart';

import '../models/hotel_layout_options.dart';
import '../widgets/amenities_section.dart';
import '../widgets/booking_bar.dart';
import '../widgets/description_section.dart';
import '../widgets/hero_image_section.dart';
import '../widgets/stats_row.dart';
import '../widgets/title_section.dart';

class HotelDetailScreen extends StatefulWidget {
  const HotelDetailScreen({super.key, required this.options});

  /// Lớn hơn mốc này thì màn hình chuyển sang bố cục 2 cột.
  static const double twoColumnBreakpoint = 600;

  final HotelLayoutOptions options;

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  // Trạng thái cục bộ: chỉ màn hình này cần biết. Đặt ở đây nên vẫn được giữ
  // khi bố cục đổi qua lại giữa 1 cột và 2 cột.
  bool _isFavorite = false;
  bool _descriptionExpanded = false;

  void _showBookingMessage() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã giữ phòng cho bạn!')));
  }

  /// SingleChildScrollView: cho phép cuộn khi nội dung cao hơn khung.
  /// Khi tắt xử lý overflow, Column vượt chiều cao và hiện vạch sọc ở đáy.
  Widget _scrollIfEnabled(Widget child) => widget.options.handleOverflow
      ? SingleChildScrollView(child: child)
      : child;

  Widget _buildHero({double? height}) {
    return HeroImageSection(
      height: height,
      isFavorite: _isFavorite,
      onToggleFavorite: () => setState(() => _isFavorite = !_isFavorite),
    );
  }

  Widget _buildInfo() {
    final options = widget.options;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleSection(options: options),
          const SizedBox(height: 16),
          StatsRow(options: options),
          const SizedBox(height: 16),
          AmenitiesSection(options: options),
          const SizedBox(height: 16),
          DescriptionSection(
            isExpanded: _descriptionExpanded,
            onToggle: () =>
                setState(() => _descriptionExpanded = !_descriptionExpanded),
          ),
        ],
      ),
    );
  }

  Widget _buildOneColumn() {
    return _scrollIfEnabled(
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _buildHero(height: 210),
          ),
          _buildInfo(),
        ],
      ),
    );
  }

  Widget _buildTwoColumns() {
    return Row(
      // stretch: hai cột cao bằng toàn bộ chiều cao được cấp.
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Expanded với flex 5:6: chia chiều rộng theo tỉ lệ cho 2 cột.
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildHero(),
          ),
        ),
        Expanded(flex: 6, child: _scrollIfEnabled(_buildInfo())),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.options;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      // LayoutBuilder: nhận ràng buộc từ widget cha (ở đây là SizedBox) nên
      // phản ứng theo khung xem trước. MediaQuery thì luôn trả về kích thước
      // cửa sổ thật, không dùng được để mô phỏng thiết bị.
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide =
              constraints.maxWidth > HotelDetailScreen.twoColumnBreakpoint;
          return Column(
            children: [
              // Expanded: phần nội dung lấy hết chiều cao còn lại, nhờ đó
              // BookingBar luôn nằm cố định ở đáy.
              Expanded(child: isWide ? _buildTwoColumns() : _buildOneColumn()),
              BookingBar(
                handleOverflow: options.handleOverflow,
                onBook: _showBookingMessage,
              ),
            ],
          );
        },
      ),
    );
  }
}
