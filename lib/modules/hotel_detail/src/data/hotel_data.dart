import 'package:flutter/material.dart';

const String kShortHotelName = 'Vịnh Xanh Resort & Spa';
const String kLongHotelName =
    'Vịnh Xanh Grand Resort & Spa Năm Sao Hướng Biển Toàn Cảnh '
    'Với Hồ Bơi Vô Cực Trên Tầng Thượng Dành Cho Cả Gia Đình';
const String kHotelAddress = '25 Đường Biển Xanh, Sơn Trà, Đà Nẵng';
const String kHotelDescription =
    'Vịnh Xanh Resort nằm ngay sát bờ biển, chỉ mất 15 phút di chuyển từ sân '
    'bay. Tất cả phòng đều có ban công riêng nhìn ra biển, nội thất gỗ tự nhiên '
    'và cửa kính lớn đón nắng buổi sớm. Khu nghỉ dưỡng có hồ bơi vô cực, nhà '
    'hàng hải sản, phòng gym mở cửa cả ngày và khu vui chơi cho trẻ em. Buổi '
    'tối, bạn có thể dạo bộ trên bãi cát riêng, thưởng thức nhạc sống ở quầy '
    'bar ngoài trời hoặc đặt liệu trình spa thư giãn. Lễ tân hỗ trợ 24/7, nhận '
    'đặt tour tham quan và xe đưa đón theo yêu cầu.';

const List<(IconData, String)> kBaseAmenities = [
  (Icons.wifi, 'Wi-Fi miễn phí'),
  (Icons.pool, 'Hồ bơi'),
  (Icons.restaurant, 'Nhà hàng'),
  (Icons.spa, 'Spa'),
];

/// Tiện ích được thêm lần lượt khi bấm nút "+ Thêm tiện ích".
const List<(IconData, String)> kExtraAmenities = [
  (Icons.fitness_center, 'Phòng gym'),
  (Icons.local_parking, 'Bãi đỗ xe'),
  (Icons.airport_shuttle, 'Xe đưa đón'),
  (Icons.child_friendly, 'Khu trẻ em'),
  (Icons.local_bar, 'Quầy bar'),
  (Icons.pets, 'Cho phép thú cưng'),
];

List<(IconData, String)> buildAmenities(int extraCount) => [
  ...kBaseAmenities,
  for (var i = 0; i < extraCount; i++)
    i < kExtraAmenities.length
        ? kExtraAmenities[i]
        : (Icons.add_circle_outline, 'Tiện ích ${i + 1}'),
];
