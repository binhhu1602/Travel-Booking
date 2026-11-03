# Travel Booking – Layout Lab

Ứng dụng Flutter minh họa bố cục linh hoạt và xử lý overflow qua màn hình chi tiết khách sạn.

Giải thích khái niệm và kịch bản demo: [GIAI_THICH.md](GIAI_THICH.md)

## Chạy

```bash
flutter run -d chrome
```

Vạch sọc overflow chỉ hiện ở debug mode.

## Cấu trúc

Mã nguồn chia theo tinh thần microservice: mỗi module tự chứa dữ liệu, model và giao diện của mình, và chỉ giao tiếp qua một cổng công khai. Đây là module trong cùng một ứng dụng, không phải các dịch vụ chạy riêng trên server.

```text
lib/
├─ main.dart                     Điểm khởi động
├─ app.dart                      Lớp vỏ: ghép theme với module
├─ core/theme/                   Màu và theme dùng chung
└─ modules/
   ├─ hotel_detail/              Màn hình chi tiết khách sạn
   │  ├─ hotel_detail.dart       Cổng công khai
   │  └─ src/
   │     ├─ data/                Dữ liệu mẫu
   │     ├─ models/              HotelLayoutOptions (hợp đồng của module)
   │     ├─ screens/             HotelDetailScreen
   │     └─ widgets/             Hero, tiêu đề, thống kê, tiện ích, mô tả, đặt phòng
   └─ layout_lab/                Bảng điều khiển và khung xem trước
      ├─ layout_lab.dart         Cổng công khai
      └─ src/
         ├─ models/              LabConfig
         ├─ screens/             LayoutLabPage
         └─ widgets/             LayoutLabPanel, PreviewArea
```

Quy tắc phụ thuộc, được kiểm tra tự động bởi [test/architecture_test.dart](test/architecture_test.dart):

- Module chỉ import module khác qua cổng công khai, không import vào `src/` của nhau.
- Phụ thuộc đi một chiều: `layout_lab` → `hotel_detail`. `LabConfig.hotelOptions` là điểm nối duy nhất.
- `core` không phụ thuộc vào module nào.

Thêm module mới: tạo `lib/modules/<ten_module>/<ten_module>.dart` làm cổng công khai, đặt phần còn lại trong `src/`, viết test trong `test/modules/<ten_module>/`.

## Kiểm thử

```bash
flutter test
```

## Bản một file cho DartPad

Cấu trúc nhiều file không dán được vào DartPad. Bản một file nằm ở commit `c3cb421`:

```bash
git show c3cb421:lib/main.dart
```
