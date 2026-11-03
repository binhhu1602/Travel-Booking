import 'package:flutter/material.dart';

import '../data/hotel_data.dart';

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({
    super.key,
    required this.isExpanded,
    required this.onToggle,
  });

  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mô tả', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 4),
        // maxLines = null: không giới hạn số dòng, hiện toàn bộ nội dung.
        Text(
          kHotelDescription,
          maxLines: isExpanded ? null : 3,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        TextButton(
          onPressed: onToggle,
          child: Text(isExpanded ? 'Thu gọn' : 'Xem thêm'),
        ),
      ],
    );
  }
}
