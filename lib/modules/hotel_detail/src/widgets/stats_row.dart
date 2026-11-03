import 'package:flutter/material.dart';

import '../models/hotel_layout_options.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key, required this.options});

  /// Chiều cao cố định lớn hơn thẻ để thấy rõ tác dụng của CrossAxisAlignment.
  /// Đây cũng là điều kiện của stretch: nếu không có chiều cao giới hạn,
  /// stretch trong vùng cuộn sẽ ép con cao vô hạn và gây lỗi.
  static const double rowHeight = 124;

  /// Chiều rộng cố định của thẻ ở chế độ Row thường.
  static const double fixedCardWidth = 120;

  final HotelLayoutOptions options;

  /// Bọc thẻ theo [HotelLayoutOptions.flexMode] để so sánh hai cách chia chỗ.
  Widget _wrapCard(Widget card, int flex) {
    if (!options.handleOverflow) {
      // Row thường: tổng 360px, khung hẹp hơn thì tràn và hiện vạch sọc.
      return SizedBox(width: fixedCardWidth, child: card);
    }
    return switch (options.flexMode) {
      // Expanded = Flexible(fit: FlexFit.tight): ép con lấp đầy phần được chia.
      // Row không còn chỗ trống nên MainAxisAlignment không có tác dụng.
      FlexDemoMode.expanded => Expanded(flex: flex, child: card),
      // FlexFit.loose: phần được chia chỉ là mức tối đa, con rộng vừa nội dung.
      // Chỗ trống còn dư được phân bổ theo MainAxisAlignment.
      FlexDemoMode.flexibleLoose => Flexible(
        flex: flex,
        fit: FlexFit.loose,
        child: card,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AxisLegend(),
        const SizedBox(height: 6),
        Container(
          height: rowHeight,
          // Hai cạnh chạy dọc theo main axis tô đỏ, hai cạnh chạy dọc theo
          // cross axis tô xanh. Với Row: main axis ngang, cross axis dọc.
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.red, width: 2),
              bottom: BorderSide(color: Colors.red, width: 2),
              left: BorderSide(color: Colors.blue, width: 2),
              right: BorderSide(color: Colors.blue, width: 2),
            ),
          ),
          child: Row(
            mainAxisAlignment: options.mainAxisAlignment,
            crossAxisAlignment: options.crossAxisAlignment,
            children: [
              // flex 2:1:1: thẻ đầu được chia gấp đôi mỗi thẻ còn lại.
              _wrapCard(
                const _StatCard(
                  icon: Icons.bed,
                  value: '128',
                  label: 'Phòng',
                  note: 'Còn 3 trống',
                ),
                2,
              ),
              _wrapCard(
                const _StatCard(
                  icon: Icons.square_foot,
                  value: '45 m²',
                  label: 'Diện tích',
                ),
                1,
              ),
              _wrapCard(
                const _StatCard(
                  icon: Icons.star_outline,
                  value: '4.8',
                  label: 'Đánh giá',
                ),
                1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AxisLegend extends StatelessWidget {
  const _AxisLegend();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall;
    // Wrap: chú thích tự xuống dòng nên không gây tràn ở khung hẹp.
    return Wrap(
      spacing: 12,
      children: [
        Text(
          'Đỏ: main axis (ngang)',
          style: style?.copyWith(color: Colors.red),
        ),
        Text(
          'Xanh: cross axis (dọc)',
          style: style?.copyWith(color: Colors.blue),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    this.note,
  });

  final IconData icon;
  final String value;
  final String label;

  /// Dòng phụ làm thẻ này cao hơn 2 thẻ kia, để thấy khác biệt trên cross axis.
  final String? note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: colors.primary),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          if (note != null)
            Text(
              note!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(color: colors.error),
            ),
        ],
      ),
    );
  }
}
