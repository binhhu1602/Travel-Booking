# Giải thích: Travel Booking – Layout Lab

Code được chia thành các module trong [lib/modules/](lib/modules/), cấu trúc xem ở [README.md](README.md). Chạy bằng `flutter run -d chrome`.

Mở Layout Lab: cửa sổ rộng từ 900px thì bảng nằm ở cột bên phải; hẹp hơn thì bấm icon điều chỉnh trên AppBar để mở Drawer.

## 1. Bảng tóm tắt khái niệm

| Khái niệm | Widget hoặc dòng code | Thao tác demo trong Layout Lab |
|---|---|---|
| `Stack` + `Positioned` | `HeroImageSection`: huy hiệu `top: 12, left: 12`, tim `top: 8, right: 8` | Bấm trái tim để đổi trạng thái; kéo slider, các lớp vẫn neo đúng góc |
| `Clip.none` | `Stack(clipBehavior: Clip.none)` + `bottom: -ratingCardHeight / 2` | Thẻ rating lấn một nửa ra ngoài ảnh ở mọi chiều rộng |
| `Expanded` trong `Row` | `TitleSection`: `Expanded(child: Column(...))` | Bật "Tên khách sạn siêu dài", tên xuống dòng rồi cắt thay vì tràn |
| `maxLines` + `TextOverflow.ellipsis` | `Text(options.hotelName, maxLines: 2, overflow: TextOverflow.ellipsis)` | Kéo slider về 240, tên và địa chỉ hiện dấu "…" |
| `flex` | `StatsRow`: `_wrapCard(card, 2)`, `_wrapCard(card, 1)`, `_wrapCard(card, 1)` | Chọn Expanded, thẻ Phòng rộng gấp đôi hai thẻ còn lại |
| `MainAxisAlignment` | `Row(mainAxisAlignment: options.mainAxisAlignment)` | Chọn Flexible rồi đổi dropdown đỏ |
| `CrossAxisAlignment` | `Row(crossAxisAlignment: options.crossAxisAlignment)` | Đổi dropdown xanh; thẻ Phòng cao hơn nên thấy rõ start, center, end, stretch |
| `Flexible(fit: FlexFit.loose)` và `Expanded` | `StatsRow._wrapCard` | Đổi segmented button trên cùng hàng thống kê |
| `Wrap` | `AmenitiesSection`: `Wrap(spacing: 8, runSpacing: 8)` | Bấm "+ Thêm tiện ích", chip tự xuống dòng |
| `SingleChildScrollView` | `_scrollIfEnabled` trong `HotelDetailScreen` | Bấm "Xem thêm", nội dung cuộn được thay vì tràn đáy |
| Hiển thị/thu gọn văn bản | `DescriptionSection`: `maxLines: isExpanded ? null : 3` | Bấm "Xem thêm / Thu gọn" |
| `Flexible` + `Expanded` trên thanh đáy | `BookingBar`: `Flexible(_PriceLabel)` + `Expanded(button)` | Kéo slider về 240, giá co lại, nút vẫn nằm trong khung |
| `SizedBox` mô phỏng thiết bị | `PreviewArea`: `SizedBox(width: config.previewWidth, ...)` | Kéo slider từ 240 đến 900 |
| `LayoutBuilder` | `HotelDetailScreen`: `constraints.maxWidth > twoColumnBreakpoint` | Kéo slider từ 600 lên 610, bố cục đổi sang 2 cột |
| Vạch sọc overflow | Nhánh `!options.handleOverflow` trong từng widget | Tắt "Bật xử lý overflow" |

**Ba điểm dễ nhầm mà app cố ý làm lộ ra:**

- **`MainAxisAlignment` không có tác dụng với `Expanded`.** `Expanded` chiếm hết chỗ trống nên không còn gì để phân bổ. Vì vậy, muốn thấy dropdown đỏ hoạt động phải chọn Flexible.
- **Phần `Flexible` loose không dùng hết sẽ không được chuyển cho `Expanded`.** Trên `BookingBar` ở 900px, nếu để mặc định thì bên phải nút sẽ có khoảng trống. App dùng `spaceBetween` để đẩy khoảng trống vào giữa.
- **`stretch` cần chiều cao giới hạn.** Trong vùng cuộn, `Row` có chiều cao không giới hạn nên `stretch` sẽ gây lỗi. `StatsRow` đặt chiều cao cố định 124px để tránh lỗi này.

## 2. Bốn kịch bản overflow thường gặp

### Row quá dài

- **Nguyên nhân:** `Row` đo các con không linh hoạt với chiều rộng vô hạn, rồi xếp chúng trên một hàng. Tổng chiều rộng vượt khung thì phần thừa không có chỗ đi. App tái hiện ở hàng thống kê (3 thẻ 120px) và hàng tiện ích khi tắt xử lý overflow.
- **Cách sửa:** bọc con bằng `Expanded` hoặc `Flexible` để chia không gian. Nếu các con nên xuống dòng thì đổi sang `Wrap`. Nếu muốn giữ một hàng thì bọc bằng `SingleChildScrollView(scrollDirection: Axis.horizontal)`.

### Text không giới hạn

- **Nguyên nhân:** `Text` chỉ xuống dòng khi biết chiều rộng tối đa. Đặt trực tiếp trong `Row`, nó nhận chiều rộng vô hạn nên dàn hết trên một dòng. Bọc thêm `Column` trong `Row` cũng không giúp gì, vì `Column` cũng nhận chiều rộng vô hạn. App tái hiện ở `TitleSection`.
- **Cách sửa:** đặt `Expanded` hoặc `Flexible` ở con trực tiếp của `Row` để `Text` có chiều rộng giới hạn, sau đó thêm `maxLines` và `overflow: TextOverflow.ellipsis`.

### Column vượt chiều cao

- **Nguyên nhân:** tổng chiều cao các con lớn hơn chiều cao cha cấp, vạch sọc hiện ở đáy. App tái hiện khi tắt xử lý overflow, rõ nhất sau khi bấm "Xem thêm".
- **Cách sửa:** bọc `Column` trong `SingleChildScrollView`, hoặc dùng `ListView` nếu danh sách dài. Đặt `ListView` bên trong `Column` thì phải bọc nó bằng `Expanded`, nếu không sẽ gặp lỗi chiều cao không giới hạn.

### Bàn phím che nội dung

- **Nguyên nhân:** bàn phím chiếm phần dưới màn hình. Mặc định `Scaffold` có `resizeToAvoidBottomInset: true` và thu nhỏ phần thân, nên `Column` không cuộn được sẽ tràn đáy. Nếu đặt `resizeToAvoidBottomInset: false` thì thân không co lại và bàn phím che mất ô nhập.
- **Cách sửa:** giữ giá trị mặc định và bọc form trong `SingleChildScrollView`. Với nội dung nổi như bottom sheet, thêm `padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)`.
- **Lưu ý:** app không có ô nhập nên kịch bản này chỉ trình bày bằng lời, không demo được trong Layout Lab.

## 3. Kịch bản thuyết trình demo (khoảng 5 phút)

**Chuẩn bị:** dùng debug mode vì vạch sọc không hiện ở release mode. Mở cửa sổ rộng từ 900px để Layout Lab nằm cạnh khung xem trước, rồi bấm "Đặt lại".

| Thời gian | Thao tác | Lời nói gợi ý |
|---|---|---|
| 0:00 – 0:30 | Giới thiệu màn hình 390px | "Đây là màn hình chi tiết khách sạn. Bên phải là Layout Lab, nơi ta thay đổi từng tham số và xem bố cục phản ứng ra sao." |
| 0:30 – 1:10 | Bấm trái tim, chỉ huy hiệu và thẻ rating | "Ảnh bìa là một Stack, mỗi lớp neo bằng Positioned. Thẻ rating có bottom âm, và nhờ Clip.none nên phần lấn ra ngoài không bị cắt." |
| 1:10 – 2:10 | Chọn Flexible (loose). Đổi dropdown đỏ: `spaceBetween`, `spaceEvenly`. Đổi dropdown xanh: `start`, `end`, `stretch` | "Với Row, main axis là chiều ngang, viền đỏ. Cross axis là chiều dọc, viền xanh. Thẻ Phòng cao hơn nên thấy rõ căn chỉnh theo chiều dọc." |
| 2:10 – 2:50 | Chuyển sang Expanded, đổi lại dropdown đỏ | "Giờ đổi dropdown đỏ không còn tác dụng. Expanded ép thẻ lấp đầy phần được chia theo tỉ lệ 2:1:1, không còn chỗ trống để phân bổ. Flexible loose thì cho phép thẻ nhỏ hơn phần được chia." |
| 2:50 – 3:40 | Kéo slider về 320, bật "Tên khách sạn siêu dài", tắt "Bật xử lý overflow", bấm "Xem thêm", rồi bật lại | "Tắt xử lý overflow, Row và Column thường cho thấy vạch sọc vàng-đen ở tên, hàng thống kê, tiện ích, thanh đáy và đáy Column. Bật lại là hết nhờ Expanded, Wrap, ellipsis và SingleChildScrollView." |
| 3:40 – 4:20 | Bấm "+ Thêm tiện ích" vài lần | "Wrap tự đưa chip xuống dòng. Nội dung tăng bao nhiêu, bố cục vẫn đúng." |
| 4:20 – 4:50 | Tắt tên dài, kéo slider từ 600 lên 610, rồi lên 900 | "Qua mốc 600px, LayoutBuilder chuyển sang 2 cột. Dùng LayoutBuilder vì nó đọc ràng buộc từ cha. MediaQuery đọc kích thước cửa sổ thật nên không phản ứng với khung mô phỏng này." |
| 4:50 – 5:00 | Bấm "Đặt lại" | "Tóm lại: Row và Column chia không gian, Expanded và Flexible quyết định ai được bao nhiêu, Wrap và cuộn xử lý nội dung tăng thêm, còn LayoutBuilder chọn bố cục theo chỗ thực có." |

**Nếu bị hỏi về bàn phím:** trình bày bằng lời theo kịch bản thứ tư ở mục 2.
