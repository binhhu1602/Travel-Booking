import 'package:flutter/material.dart';

import '../data/hotel_data.dart';

/// Hai cách cho con của Row chiếm không gian trên hàng thống kê.
enum FlexDemoMode { flexibleLoose, expanded }

/// Hợp đồng công khai của module: bên ngoài chỉ cần biết class này để điều khiển
/// bố cục, không cần biết bên trong màn hình được chia thành widget nào.
class HotelLayoutOptions {
  const HotelLayoutOptions({
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.useLongName = false,
    this.extraAmenities = 0,
    this.handleOverflow = true,
    this.flexMode = FlexDemoMode.expanded,
  });

  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool useLongName;
  final int extraAmenities;
  final bool handleOverflow;
  final FlexDemoMode flexMode;

  String get hotelName => useLongName ? kLongHotelName : kShortHotelName;
}
