import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_booking/main.dart';

/// Dựng HotelDetailScreen trong khung cố định và trả về các lỗi layout bắt được.
Future<List<FlutterErrorDetails>> pumpDetail(
  WidgetTester tester,
  LabConfig config, {
  double height = 760,
}) async {
  final errors = <FlutterErrorDetails>[];
  final original = FlutterError.onError;
  FlutterError.onError = errors.add;
  addTearDown(() => FlutterError.onError = original);

  tester.view.physicalSize = const Size(1400, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: config.previewWidth,
            height: height,
            child: HotelDetailScreen(config: config),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  FlutterError.onError = original;
  return errors;
}

bool isOverflow(FlutterErrorDetails details) =>
    details.exceptionAsString().contains('overflowed');

void main() {
  group('Bật xử lý overflow', () {
    for (final width in [240.0, 320.0, 390.0, 600.0, 601.0, 900.0]) {
      testWidgets('không tràn ở $width px với nội dung tối đa', (tester) async {
        final errors = await pumpDetail(
          tester,
          LabConfig(
            previewWidth: width,
            useLongName: true,
            extraAmenities: 12,
          ),
        );
        expect(errors, isEmpty);
      });
    }

    testWidgets('mọi tổ hợp căn chỉnh và chế độ flex đều không lỗi', (
      tester,
    ) async {
      for (final mode in FlexDemoMode.values) {
        for (final main in MainAxisAlignment.values) {
          for (final cross in LayoutLabPanel.crossOptions) {
            for (final width in [240.0, 390.0, 900.0]) {
              final errors = await pumpDetail(
                tester,
                LabConfig(
                  previewWidth: width,
                  mainAxisAlignment: main,
                  crossAxisAlignment: cross,
                  flexMode: mode,
                ),
              );
              expect(errors, isEmpty, reason: '$mode $main $cross $width');
            }
          }
        }
      }
    });
  });

  group('Tắt xử lý overflow', () {
    testWidgets('khung hẹp có lỗi tràn hàng ngang', (tester) async {
      final errors = await pumpDetail(
        tester,
        const LabConfig(previewWidth: 320, handleOverflow: false),
      );
      expect(errors.where(isOverflow), isNotEmpty);
    });

    testWidgets('khung thấp có lỗi tràn Column', (tester) async {
      final errors = await pumpDetail(
        tester,
        const LabConfig(previewWidth: 900, handleOverflow: false),
        height: 320,
      );
      expect(
        errors.where(
          (e) => e.exceptionAsString().contains('on the bottom'),
        ),
        isNotEmpty,
      );
    });
  });

  group('StatsRow', () {
    double cardWidth(WidgetTester tester, String label) {
      final card = find.ancestor(
        of: find.text(label),
        matching: find.byType(Container),
      );
      return tester.getSize(card.first).width;
    }

    testWidgets('Expanded chia đúng tỉ lệ 2:1:1', (tester) async {
      await pumpDetail(tester, const LabConfig(previewWidth: 500));
      final first = cardWidth(tester, 'Phòng');
      final second = cardWidth(tester, 'Diện tích');
      final third = cardWidth(tester, 'Đánh giá');
      expect(first, moreOrLessEquals(second * 2, epsilon: 1));
      expect(second, moreOrLessEquals(third, epsilon: 1));
    });

    testWidgets('Flexible loose chừa chỗ trống cho MainAxisAlignment', (
      tester,
    ) async {
      const width = 500.0;
      await pumpDetail(
        tester,
        const LabConfig(
          previewWidth: width,
          flexMode: FlexDemoMode.flexibleLoose,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      );
      expect(cardWidth(tester, 'Phòng'), lessThan((width - 36) / 2 - 6));
      final firstRight = tester
          .getTopRight(
            find
                .ancestor(
                  of: find.text('Phòng'),
                  matching: find.byType(Container),
                )
                .first,
          )
          .dx;
      final secondLeft = tester
          .getTopLeft(
            find
                .ancestor(
                  of: find.text('Diện tích'),
                  matching: find.byType(Container),
                )
                .first,
          )
          .dx;
      expect(secondLeft - firstRight, greaterThan(20));
    });
  });

  testWidgets('LayoutBuilder chuyển 2 cột khi rộng hơn 600px', (tester) async {
    await pumpDetail(tester, const LabConfig(previewWidth: 600));
    final narrowHero = tester.getTopLeft(find.byType(HeroImageSection));
    final narrowTitle = tester.getTopLeft(find.byType(TitleSection));
    expect(narrowTitle.dy, greaterThan(narrowHero.dy + 200));

    await pumpDetail(tester, const LabConfig(previewWidth: 601));
    final wideHero = tester.getRect(find.byType(HeroImageSection));
    final wideTitle = tester.getTopLeft(find.byType(TitleSection));
    expect(wideTitle.dx, greaterThanOrEqualTo(wideHero.right));
    expect(wideTitle.dy, lessThan(wideHero.bottom));
  });

  testWidgets('Thẻ rating lấn đúng một nửa ra ngoài ảnh', (tester) async {
    await pumpDetail(tester, const LabConfig());
    final cover = tester.getRect(find.byIcon(Icons.apartment));
    expect(cover, isNotNull);
    final hero = tester.getRect(find.byType(HeroImageSection));
    final card = tester
        .getRect(
          find
              .ancestor(
                of: find.text('Tuyệt vời'),
                matching: find.byType(Container),
              )
              .first,
        );
    expect(card.height, HeroImageSection.ratingCardHeight);
    final imageBottom = hero.bottom - HeroImageSection.ratingCardHeight / 2;
    expect(card.center.dy, moreOrLessEquals(imageBottom));
  });

  testWidgets('Nút Đặt phòng sát lề phải dù giá tiền ngắn', (tester) async {
    await pumpDetail(tester, const LabConfig(previewWidth: 900));
    final bar = tester.getRect(find.byType(BookingBar));
    final button = tester.getRect(find.byType(FilledButton));
    expect(button.right, moreOrLessEquals(bar.right - 16));
  });

  testWidgets('Yêu thích và Xem thêm đổi trạng thái, giữ khi đổi bố cục', (
    tester,
  ) async {
    await pumpDetail(tester, const LabConfig());
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();
    expect(find.byIcon(Icons.favorite), findsOneWidget);

    await tester.ensureVisible(find.text('Xem thêm'));
    await tester.tap(find.text('Xem thêm'));
    await tester.pump();
    expect(find.text('Thu gọn'), findsOneWidget);

    await pumpDetail(tester, const LabConfig(previewWidth: 800));
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.text('Thu gọn'), findsOneWidget);
  });

  group('LayoutLabPage', () {
    Future<void> pumpApp(WidgetTester tester, Size size) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const TravelBookingApp());
    }

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
      expect(
        find.textContaining('Thẻ chỉ rộng vừa nội dung'),
        findsOneWidget,
      );
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
  });
}
