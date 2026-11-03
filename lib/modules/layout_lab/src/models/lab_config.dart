import 'package:flutter/material.dart';
import 'package:travel_booking/modules/hotel_detail/hotel_detail.dart';

const double kMinPreviewWidth = 240;
const double kMaxPreviewWidth = 900;

/// Toàn bộ cấu hình demo. Dữ liệu bất biến, mỗi lần đổi tạo một bản mới.
class LabConfig {
  const LabConfig({
    this.previewWidth = 390,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.useLongName = false,
    this.extraAmenities = 0,
    this.handleOverflow = true,
    this.flexMode = FlexDemoMode.expanded,
  });

  final double previewWidth;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool useLongName;
  final int extraAmenities;
  final bool handleOverflow;
  final FlexDemoMode flexMode;

  bool get isTwoColumn => previewWidth > HotelDetailScreen.twoColumnBreakpoint;

  /// Chuyển sang hợp đồng của module hotel_detail. Đây là điểm nối duy nhất
  /// giữa hai module, nên chiều rộng khung xem trước không lọt sang bên kia.
  HotelLayoutOptions get hotelOptions => HotelLayoutOptions(
    mainAxisAlignment: mainAxisAlignment,
    crossAxisAlignment: crossAxisAlignment,
    useLongName: useLongName,
    extraAmenities: extraAmenities,
    handleOverflow: handleOverflow,
    flexMode: flexMode,
  );

  LabConfig copyWith({
    double? previewWidth,
    MainAxisAlignment? mainAxisAlignment,
    CrossAxisAlignment? crossAxisAlignment,
    bool? useLongName,
    int? extraAmenities,
    bool? handleOverflow,
    FlexDemoMode? flexMode,
  }) {
    return LabConfig(
      previewWidth: previewWidth ?? this.previewWidth,
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment ?? this.crossAxisAlignment,
      useLongName: useLongName ?? this.useLongName,
      extraAmenities: extraAmenities ?? this.extraAmenities,
      handleOverflow: handleOverflow ?? this.handleOverflow,
      flexMode: flexMode ?? this.flexMode,
    );
  }
}
