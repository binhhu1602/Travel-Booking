import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'modules/layout_lab/layout_lab.dart';

/// Lớp vỏ ứng dụng: chỉ ghép theme với module, không chứa nghiệp vụ.
class TravelBookingApp extends StatelessWidget {
  const TravelBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Booking',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const LayoutLabPage(),
    );
  }
}
