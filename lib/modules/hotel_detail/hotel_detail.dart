/// Cổng công khai của module hotel_detail.
///
/// Module khác chỉ được import file này, không import trực tiếp vào src/.
library;

export 'src/data/hotel_data.dart' show buildAmenities;
export 'src/models/hotel_layout_options.dart';
export 'src/screens/hotel_detail_screen.dart' show HotelDetailScreen;
