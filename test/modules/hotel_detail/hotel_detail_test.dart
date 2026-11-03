import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:travel_booking/modules/hotel_detail/hotel_detail.dart';
import 'package:travel_booking/modules/hotel_detail/src/widgets/booking_bar.dart';
import 'package:travel_booking/modules/hotel_detail/src/widgets/hero_image_section.dart';
import 'package:travel_booking/modules/hotel_detail/src/widgets/title_section.dart';

/// Dựng HotelDetailScreen trong khung cố định và trả về các lỗi layout bắt được.
Future<List<FlutterErrorDetails>> pumpDetail(
  WidgetTester tester,
  HotelLayoutOptions options, {
  double width = 390,
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
            width: width,
            height: height,
            child: HotelDetailScreen(options: options),
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
          const HotelLayoutOptions(useLongName: true, extraAmenities: 12),
          width: width,
        );
        expect(errors, isEmpty);
      });
    }

    testWidgets('mọi tổ hợp căn chỉnh và chế độ flex đều không lỗi', (
      tester,
    ) async {
      const crossOptions = [
        CrossAxisAlignment.start,
        CrossAxisAlignment.center,
        CrossAxisAlignment.end,
        CrossAxisAlignment.stretch,
      ];
      for (final mode in FlexDemoMode.values) {
        for (final main in MainAxisAlignment.values) {
          for (final cross in crossOptions) {
            for (final width in [240.0, 390.0, 900.0]) {
              final errors = await pumpDetail(
                tester,
                HotelLayoutOptions(
                  mainAxisAlignment: main,
                  crossAxisAlignment: cross,
                  flexMode: mode,
                ),
                width: width,
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
        const HotelLayoutOptions(handleOverflow: false),
        width: 320,
      );
      expect(errors.where(isOverflow), isNotEmpty);
    });

    testWidgets('khung thấp có lỗi tràn Column', (tester) async {
      final errors = await pumpDetail(
        tester,
        const HotelLayoutOptions(handleOverflow: false),
        width: 900,
        height: 320,
      );
      expect(
        errors.where((e) => e.exceptionAsString().contains('on the bottom')),
        isNotEmpty,
      );
    });
  });

  group('StatsRow', () {
    Finder cardOf(String label) => find
        .ancestor(of: find.text(label), matching: find.byType(Container))
        .first;

    testWidgets('Expanded chia đúng tỉ lệ 2:1:1', (tester) async {
      await pumpDetail(tester, const HotelLayoutOptions(), width: 500);
      final first = tester.getSize(cardOf('Phòng')).width;
      final second = tester.getSize(cardOf('Diện tích')).width;
      final third = tester.getSize(cardOf('Đánh giá')).width;
      expect(first, moreOrLessEquals(second * 2, epsilon: 1));
      expect(second, moreOrLessEquals(third, epsilon: 1));
    });

    testWidgets('Flexible loose chừa chỗ trống cho MainAxisAlignment', (
      tester,
    ) async {
      const width = 500.0;
      await pumpDetail(
        tester,
        const HotelLayoutOptions(
          flexMode: FlexDemoMode.flexibleLoose,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
        width: width,
      );
      expect(
        tester.getSize(cardOf('Phòng')).width,
        lessThan((width - 36) / 2 - 6),
      );
      final firstRight = tester.getTopRight(cardOf('Phòng')).dx;
      final secondLeft = tester.getTopLeft(cardOf('Diện tích')).dx;
      expect(secondLeft - firstRight, greaterThan(20));
    });
  });

  testWidgets('LayoutBuilder chuyển 2 cột khi rộng hơn 600px', (tester) async {
    await pumpDetail(tester, const HotelLayoutOptions(), width: 600);
    final narrowHero = tester.getTopLeft(find.byType(HeroImageSection));
    final narrowTitle = tester.getTopLeft(find.byType(TitleSection));
    expect(narrowTitle.dy, greaterThan(narrowHero.dy + 200));

    await pumpDetail(tester, const HotelLayoutOptions(), width: 601);
    final wideHero = tester.getRect(find.byType(HeroImageSection));
    final wideTitle = tester.getTopLeft(find.byType(TitleSection));
    expect(wideTitle.dx, greaterThanOrEqualTo(wideHero.right));
    expect(wideTitle.dy, lessThan(wideHero.bottom));
  });

  testWidgets('Thẻ rating lấn đúng một nửa ra ngoài ảnh', (tester) async {
    await pumpDetail(tester, const HotelLayoutOptions());
    final hero = tester.getRect(find.byType(HeroImageSection));
    final card = tester.getRect(
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
    await pumpDetail(tester, const HotelLayoutOptions(), width: 900);
    final bar = tester.getRect(find.byType(BookingBar));
    final button = tester.getRect(find.byType(FilledButton));
    expect(button.right, moreOrLessEquals(bar.right - 16));
  });

  testWidgets('Yêu thích và Xem thêm đổi trạng thái, giữ khi đổi bố cục', (
    tester,
  ) async {
    await pumpDetail(tester, const HotelLayoutOptions());
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();
    expect(find.byIcon(Icons.favorite), findsOneWidget);

    await tester.ensureVisible(find.text('Xem thêm'));
    await tester.tap(find.text('Xem thêm'));
    await tester.pump();
    expect(find.text('Thu gọn'), findsOneWidget);

    await pumpDetail(tester, const HotelLayoutOptions(), width: 800);
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.text('Thu gọn'), findsOneWidget);
  });
}
