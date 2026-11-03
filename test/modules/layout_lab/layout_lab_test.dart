import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_booking/app.dart';
import 'package:travel_booking/modules/hotel_detail/hotel_detail.dart';
import 'package:travel_booking/modules/layout_lab/src/models/lab_config.dart';
import 'package:travel_booking/modules/layout_lab/src/widgets/layout_lab_panel.dart';

Future<void> pumpApp(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const TravelBookingApp());
}

void main() {
  test('LabConfig chuyển đủ các trường sang hợp đồng của hotel_detail', () {
    const config = LabConfig(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      useLongName: true,
      extraAmenities: 3,
      handleOverflow: false,
      flexMode: FlexDemoMode.flexibleLoose,
    );
    final options = config.hotelOptions;
    expect(options.mainAxisAlignment, MainAxisAlignment.spaceEvenly);
    expect(options.crossAxisAlignment, CrossAxisAlignment.end);
    expect(options.useLongName, isTrue);
    expect(options.extraAmenities, 3);
    expect(options.handleOverflow, isFalse);
    expect(options.flexMode, FlexDemoMode.flexibleLoose);
  });

  testWidgets('cửa sổ rộng hiện panel ở cột bên cạnh', (tester) async {
    await pumpApp(tester, const Size(1300, 900));
    expect(find.byType(LayoutLabPanel), findsOneWidget);
    expect(find.byTooltip('Mở Layout Lab'), findsNothing);
    expect(find.text('390 px · Điện thoại · 1 cột'), findsOneWidget);
  });

  testWidgets('cửa sổ hẹp mở panel bằng Drawer, chỉnh được ngay', (
    tester,
  ) async {
    await pumpApp(tester, const Size(700, 900));
    expect(find.byType(LayoutLabPanel), findsNothing);
    await tester.tap(find.byTooltip('Mở Layout Lab'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Flexible (loose)'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Thẻ chỉ rộng vừa nội dung'), findsOneWidget);
  });

  testWidgets('khung 900px hoạt động trong cửa sổ nhỏ hơn', (tester) async {
    await pumpApp(tester, const Size(1000, 900));
    tester
        .widget<LayoutLabPanel>(find.byType(LayoutLabPanel))
        .onChanged(const LabConfig(previewWidth: 900));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(tester.getSize(find.byType(HotelDetailScreen)).width, 900);
  });
}
