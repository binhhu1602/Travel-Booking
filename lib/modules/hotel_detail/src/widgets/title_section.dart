import 'package:flutter/material.dart';
import 'package:travel_booking/core/theme/app_colors.dart';

import '../data/hotel_data.dart';
import '../models/hotel_layout_options.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.options});

  final HotelLayoutOptions options;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final nameStyle = textTheme.titleLarge;
    final addressStyle = textTheme.bodyMedium?.copyWith(color: kTextSecondary);
    final icon = Icon(
      Icons.location_on,
      color: Theme.of(context).colorScheme.primary,
    );

    if (!options.handleOverflow) {
      // Row thường + Text tự do: Row đo con với chiều rộng vô hạn, Text dàn
      // hết trên một dòng và vượt khung, Flutter vẽ vạch sọc vàng-đen.
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(options.hotelName, style: nameStyle),
              Text(kHotelAddress, style: addressStyle),
            ],
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 8),
        // Expanded: chiếm toàn bộ không gian còn lại trên main axis, nên Text
        // bên trong có chiều rộng giới hạn và biết lúc nào phải xuống dòng.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // maxLines + ellipsis: quá 2 dòng thì cắt và thêm dấu "…".
              Text(
                options.hotelName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: nameStyle,
              ),
              Text(
                kHotelAddress,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: addressStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
