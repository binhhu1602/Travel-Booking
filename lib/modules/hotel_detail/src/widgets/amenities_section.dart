import 'package:flutter/material.dart';

import '../data/hotel_data.dart';
import '../models/hotel_layout_options.dart';

class AmenitiesSection extends StatelessWidget {
  const AmenitiesSection({super.key, required this.options});

  final HotelLayoutOptions options;

  @override
  Widget build(BuildContext context) {
    final chips = [
      for (final (icon, label) in buildAmenities(options.extraAmenities))
        Chip(
          avatar: Icon(icon, size: 16),
          label: Text(label),
          visualDensity: VisualDensity.compact,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tiện ích', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        options.handleOverflow
            // Wrap: hết chỗ trên dòng hiện tại thì tự đưa con xuống dòng mới.
            // spacing là khoảng cách ngang, runSpacing là khoảng cách giữa dòng.
            ? Wrap(spacing: 8, runSpacing: 8, children: chips)
            // Row không bao giờ xuống dòng: thêm tiện ích là tràn khung.
            : Row(children: chips),
      ],
    );
  }
}
