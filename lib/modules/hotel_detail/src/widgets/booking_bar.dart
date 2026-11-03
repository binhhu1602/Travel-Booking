import 'package:flutter/material.dart';

class BookingBar extends StatelessWidget {
  const BookingBar({
    super.key,
    required this.handleOverflow,
    required this.onBook,
  });

  /// Chiều rộng cố định của nút ở chế độ Row thường.
  static const double fixedButtonWidth = 200;

  final bool handleOverflow;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final button = FilledButton(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      onPressed: onBook,
      child: const Text(
        'Đặt phòng',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        // Phần Flexible loose không dùng hết sẽ KHÔNG được chuyển cho Expanded,
        // nên dùng spaceBetween để đẩy chỗ dư vào giữa, nút nằm sát lề phải.
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: handleOverflow
            ? [
                // Flexible: giá tiền ngắn thì chỉ rộng vừa đủ, khung hẹp thì co
                // lại và cắt bằng ellipsis.
                const Flexible(child: _PriceLabel(handleOverflow: true)),
                const SizedBox(width: 12),
                // Expanded: nút luôn lấp đầy toàn bộ phần được chia theo flex.
                Expanded(child: button),
              ]
            : [
                // Row thường: giá + nút rộng cố định, khung hẹp sẽ tràn.
                const _PriceLabel(handleOverflow: false),
                const SizedBox(width: 12),
                SizedBox(width: fixedButtonWidth, child: button),
              ],
      ),
    );
  }
}

class _PriceLabel extends StatelessWidget {
  const _PriceLabel({required this.handleOverflow});

  final bool handleOverflow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxLines = handleOverflow ? 1 : null;
    final overflow = handleOverflow ? TextOverflow.ellipsis : null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2.400.000đ',
          maxLines: maxLines,
          overflow: overflow,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text.rich(
          const TextSpan(
            children: [
              TextSpan(
                text: '3.000.000đ',
                style: TextStyle(decoration: TextDecoration.lineThrough),
              ),
              TextSpan(text: ' / đêm'),
            ],
          ),
          maxLines: maxLines,
          overflow: overflow,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
