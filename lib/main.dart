// Travel Booking – Màn hình chi tiết khách sạn kèm Layout Lab.
//
// Ứng dụng 1 file, chỉ dùng thư viện chuẩn, dán thẳng vào DartPad là chạy được.
// Mục tiêu: minh họa bố cục linh hoạt và cách xử lý không gian trong Flutter.
//
// Sơ đồ widget:
//   LayoutLabPage (giữ toàn bộ cấu hình demo)
//   ├─ LayoutLabPanel (bảng điều khiển: Drawer hoặc cột bên cạnh)
//   └─ HotelDetailScreen (màn hình chính, được bọc trong SizedBox)
//      ├─ HeroImageSection
//      ├─ TitleSection
//      ├─ StatsRow
//      ├─ AmenitiesSection
//      ├─ DescriptionSection
//      └─ BookingBar

import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(const TravelBookingApp());

// ---------------------------------------------------------------------------
// HẰNG SỐ VÀ DỮ LIỆU MẪU
// ---------------------------------------------------------------------------

const Color kBrandBlue = Color(0xFF1565C0);

/// Lớn hơn mốc này thì màn hình chi tiết chuyển sang bố cục 2 cột.
const double kTwoColumnBreakpoint = 600;

const double kMinPreviewWidth = 240;
const double kMaxPreviewWidth = 900;

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

/// Hai cách cho con của Row chiếm không gian, dùng cho segmented button.
enum FlexDemoMode { flexibleLoose, expanded }

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

  String get hotelName => useLongName ? kLongHotelName : kShortHotelName;

  bool get isTwoColumn => previewWidth > kTwoColumnBreakpoint;

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

// ---------------------------------------------------------------------------
// ỨNG DỤNG VÀ TRANG CHỨA
// ---------------------------------------------------------------------------

class TravelBookingApp extends StatelessWidget {
  const TravelBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Booking',
      debugShowCheckedModeBanner: false,
      // Material 3: toàn bộ bảng màu được sinh ra từ một màu xanh dương gốc.
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: kBrandBlue),
      ),
      home: const LayoutLabPage(),
    );
  }
}

/// Trang chứa khung xem trước và bảng Layout Lab.
class LayoutLabPage extends StatefulWidget {
  const LayoutLabPage({super.key});

  @override
  State<LayoutLabPage> createState() => _LayoutLabPageState();
}

class _LayoutLabPageState extends State<LayoutLabPage> {
  /// Cửa sổ từ mốc này trở lên thì đặt Layout Lab thành cột bên cạnh.
  static const double _sidePanelBreakpoint = 900;

  // Trạng thái nằm ở widget cha chung để cả bảng điều khiển và màn hình xem
  // trước cùng đọc được (kỹ thuật "nâng trạng thái lên").
  LabConfig _config = const LabConfig();

  final ScrollController _previewScroll = ScrollController();

  @override
  void dispose() {
    _previewScroll.dispose();
    super.dispose();
  }

  void _updateConfig(LabConfig next) => setState(() => _config = next);

  @override
  Widget build(BuildContext context) {
    final panel = LayoutLabPanel(config: _config, onChanged: _updateConfig);
    final preview = _PreviewArea(config: _config, controller: _previewScroll);

    // LayoutBuilder: đọc chiều rộng thật của cửa sổ để chọn vị trí đặt bảng.
    return LayoutBuilder(
      builder: (context, constraints) {
        final hasSidePanel = constraints.maxWidth >= _sidePanelBreakpoint;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Travel Booking · Layout Lab'),
            actions: [
              if (!hasSidePanel)
                // Builder: tạo context nằm dưới Scaffold để gọi Scaffold.of().
                Builder(
                  builder: (context) => IconButton(
                    tooltip: 'Mở Layout Lab',
                    icon: const Icon(Icons.tune),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
            ],
          ),
          // Drawer vẫn nằm trong cây của Scaffold nên setState ở trang này cập
          // nhật được bảng điều khiển ngay khi Drawer đang mở.
          endDrawer: hasSidePanel
              ? null
              : Drawer(width: 320, child: SafeArea(child: panel)),
          // Màn che rất nhạt để vẫn nhìn thấy khung xem trước khi chỉnh.
          drawerScrimColor: Colors.black12,
          body: hasSidePanel
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Expanded: khung xem trước lấy toàn bộ phần còn lại.
                    Expanded(child: preview),
                    const VerticalDivider(width: 1),
                    SizedBox(width: 340, child: panel),
                  ],
                )
              : preview,
        );
      },
    );
  }
}

/// Khu vực mô phỏng thiết bị: bọc màn hình chi tiết trong SizedBox.
class _PreviewArea extends StatelessWidget {
  const _PreviewArea({required this.config, required this.controller});

  final LabConfig config;
  final ScrollController controller;

  String get _deviceName {
    final width = config.previewWidth;
    if (width < 360) return 'Điện thoại nhỏ';
    if (width <= kTwoColumnBreakpoint) return 'Điện thoại';
    if (width < 840) return 'Máy tính bảng dọc';
    return 'Máy tính bảng ngang';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const padding = EdgeInsets.fromLTRB(16, 8, 16, 20);

    return ColoredBox(
      color: colors.surfaceContainerLow,
      child: LayoutBuilder(
        builder: (context, viewport) {
          final frameHeight = math.max(
            0.0,
            math.min(viewport.maxHeight - padding.vertical, 820.0),
          );

          // SingleChildScrollView ngang: không giới hạn chiều rộng cho con, nhờ
          // vậy khung 900px vẫn đúng 900px dù cửa sổ thật nhỏ hơn.
          return Scrollbar(
            controller: controller,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              padding: padding,
              child: ConstrainedBox(
                // Khung hẹp hơn cửa sổ thì vẫn được căn giữa.
                constraints: BoxConstraints(
                  minWidth: math.max(0, viewport.maxWidth - padding.horizontal),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  // SizedBox: ép cứng kích thước để mô phỏng từng loại thiết bị.
                  child: SizedBox(
                    width: config.previewWidth,
                    height: frameHeight,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 28,
                          child: Text(
                            '${config.previewWidth.round()} px · $_deviceName · '
                            '${config.isTwoColumn ? '2 cột' : '1 cột'}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: HotelDetailScreen(config: config),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// MÀN HÌNH CHI TIẾT KHÁCH SẠN
// ---------------------------------------------------------------------------

class HotelDetailScreen extends StatefulWidget {
  const HotelDetailScreen({super.key, required this.config});

  final LabConfig config;

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  // Trạng thái cục bộ: chỉ màn hình này cần biết. Đặt ở đây nên vẫn được giữ
  // khi bố cục đổi qua lại giữa 1 cột và 2 cột.
  bool _isFavorite = false;
  bool _descriptionExpanded = false;

  void _showBookingMessage() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã giữ phòng cho bạn!')));
  }

  /// SingleChildScrollView: cho phép cuộn khi nội dung cao hơn khung.
  /// Khi tắt xử lý overflow, Column vượt chiều cao và hiện vạch sọc ở đáy.
  Widget _scrollIfEnabled(Widget child) => widget.config.handleOverflow
      ? SingleChildScrollView(child: child)
      : child;

  Widget _buildHero({double? height}) {
    return HeroImageSection(
      height: height,
      isFavorite: _isFavorite,
      onToggleFavorite: () => setState(() => _isFavorite = !_isFavorite),
    );
  }

  Widget _buildInfo() {
    final config = widget.config;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleSection(config: config),
          const SizedBox(height: 16),
          StatsRow(config: config),
          const SizedBox(height: 16),
          AmenitiesSection(config: config),
          const SizedBox(height: 16),
          DescriptionSection(
            isExpanded: _descriptionExpanded,
            onToggle: () =>
                setState(() => _descriptionExpanded = !_descriptionExpanded),
          ),
        ],
      ),
    );
  }

  Widget _buildOneColumn() {
    return _scrollIfEnabled(
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: _buildHero(height: 210),
          ),
          _buildInfo(),
        ],
      ),
    );
  }

  Widget _buildTwoColumns() {
    return Row(
      // stretch: hai cột cao bằng toàn bộ chiều cao được cấp.
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Expanded với flex 5:6: chia chiều rộng theo tỉ lệ cho 2 cột.
        Expanded(
          flex: 5,
          child: Padding(padding: const EdgeInsets.all(16), child: _buildHero()),
        ),
        Expanded(flex: 6, child: _scrollIfEnabled(_buildInfo())),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    return Material(
      color: Theme.of(context).colorScheme.surface,
      // LayoutBuilder: nhận ràng buộc từ widget cha (ở đây là SizedBox) nên
      // phản ứng theo khung xem trước. MediaQuery thì luôn trả về kích thước
      // cửa sổ thật, không dùng được để mô phỏng thiết bị.
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > kTwoColumnBreakpoint;
          return Column(
            children: [
              // Expanded: phần nội dung lấy hết chiều cao còn lại, nhờ đó
              // BookingBar luôn nằm cố định ở đáy.
              Expanded(child: isWide ? _buildTwoColumns() : _buildOneColumn()),
              BookingBar(
                handleOverflow: config.handleOverflow,
                onBook: _showBookingMessage,
              ),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ẢNH BÌA
// ---------------------------------------------------------------------------

class HeroImageSection extends StatelessWidget {
  const HeroImageSection({
    super.key,
    required this.isFavorite,
    required this.onToggleFavorite,
    this.height,
  });

  static const double ratingCardHeight = 64;

  /// Bỏ trống thì ảnh cao bằng toàn bộ chiều cao cha cấp (bố cục 2 cột).
  final double? height;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Chừa sẵn phần thẻ rating lấn xuống. Stack không tính phần tràn vào kích
      // thước của nó, nếu không chừa thì thẻ sẽ đè lên nội dung bên dưới.
      padding: const EdgeInsets.only(bottom: ratingCardHeight / 2),
      child: SizedBox(
        height: height ?? double.infinity,
        // Stack: xếp chồng các lớp theo trục z, con sau nằm trên con trước.
        child: Stack(
          fit: StackFit.expand,
          // Clip.none: cho phép con vẽ ra ngoài biên Stack. Mặc định là
          // Clip.hardEdge, khi đó nửa dưới thẻ rating bị cắt mất.
          clipBehavior: Clip.none,
          children: [
            const _CoverImage(),
            // Positioned: neo con theo khoảng cách tới các cạnh của Stack.
            const Positioned(top: 12, left: 12, child: _DiscountBadge()),
            Positioned(
              top: 8,
              right: 8,
              child: _FavoriteButton(
                isFavorite: isFavorite,
                onPressed: onToggleFavorite,
              ),
            ),
            // bottom âm: đẩy thẻ xuống dưới đáy Stack đúng một nửa chiều cao.
            // Có left + right nên chiều rộng thẻ được xác định bởi 2 cạnh neo.
            const Positioned(
              left: 16,
              right: 16,
              bottom: -ratingCardHeight / 2,
              height: ratingCardHeight,
              child: _RatingCard(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // Ảnh bìa dùng gradient, không cần tải ảnh mạng.
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D47A1), Color(0xFF1E88E5), Color(0xFF80DEEA)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        Icons.apartment,
        size: 84,
        color: Colors.white.withValues(alpha: 0.75),
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors.error,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '-20%',
        style: TextStyle(color: colors.onError, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, required this.onPressed});

  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: IconButton(
        tooltip: isFavorite ? 'Bỏ yêu thích' : 'Yêu thích',
        onPressed: onPressed,
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.redAccent,
        ),
      ),
    );
  }
}

class _RatingCard extends StatelessWidget {
  const _RatingCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, color: Colors.amber, size: 30),
          const SizedBox(width: 8),
          Text(
            '4.8',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          // Expanded + ellipsis: chữ tự co lại trên khung xem trước hẹp.
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tuyệt vời',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge,
                ),
                Text(
                  '1.280 đánh giá',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TIÊU ĐỀ
// ---------------------------------------------------------------------------

class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.config});

  final LabConfig config;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final nameStyle = textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.bold,
    );
    final icon = Icon(
      Icons.location_on,
      color: Theme.of(context).colorScheme.primary,
    );

    if (!config.handleOverflow) {
      // Row thường + Text tự do: Row đo con với chiều rộng vô hạn, Text dàn
      // hết trên một dòng và vượt khung, Flutter vẽ vạch sọc vàng-đen.
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(config.hotelName, style: nameStyle),
              Text(kHotelAddress, style: textTheme.bodyMedium),
            ],
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 8),
        // Expanded: chiếm toàn bộ không gian còn lại trên main axis, nên Text
        // bên trong có chiều rộng giới hạn và biết lúc nào phải xuống dòng.
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // maxLines + ellipsis: quá 2 dòng thì cắt và thêm dấu "…".
              Text(
                config.hotelName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: nameStyle,
              ),
              Text(
                kHotelAddress,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// HÀNG THỐNG KÊ
// ---------------------------------------------------------------------------

class StatsRow extends StatelessWidget {
  const StatsRow({super.key, required this.config});

  /// Chiều cao cố định lớn hơn thẻ để thấy rõ tác dụng của CrossAxisAlignment.
  /// Đây cũng là điều kiện của stretch: nếu không có chiều cao giới hạn,
  /// stretch trong vùng cuộn sẽ ép con cao vô hạn và gây lỗi.
  static const double rowHeight = 124;

  /// Chiều rộng cố định của thẻ ở chế độ Row thường.
  static const double fixedCardWidth = 120;

  final LabConfig config;

  /// Bọc thẻ theo chế độ đang chọn, đây là phần so sánh chính của Layout Lab.
  Widget _wrapCard(Widget card, int flex) {
    if (!config.handleOverflow) {
      // Row thường: tổng 360px, khung hẹp hơn thì tràn và hiện vạch sọc.
      return SizedBox(width: fixedCardWidth, child: card);
    }
    return switch (config.flexMode) {
      // Expanded = Flexible(fit: FlexFit.tight): ép con lấp đầy phần được chia.
      // Row không còn chỗ trống nên MainAxisAlignment không có tác dụng.
      FlexDemoMode.expanded => Expanded(flex: flex, child: card),
      // FlexFit.loose: phần được chia chỉ là mức tối đa, con rộng vừa nội dung.
      // Chỗ trống còn dư được phân bổ theo MainAxisAlignment.
      FlexDemoMode.flexibleLoose => Flexible(
        flex: flex,
        fit: FlexFit.loose,
        child: card,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AxisLegend(),
        const SizedBox(height: 6),
        Container(
          height: rowHeight,
          // Hai cạnh chạy dọc theo main axis tô đỏ, hai cạnh chạy dọc theo
          // cross axis tô xanh. Với Row: main axis ngang, cross axis dọc.
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.red, width: 2),
              bottom: BorderSide(color: Colors.red, width: 2),
              left: BorderSide(color: Colors.blue, width: 2),
              right: BorderSide(color: Colors.blue, width: 2),
            ),
          ),
          child: Row(
            mainAxisAlignment: config.mainAxisAlignment,
            crossAxisAlignment: config.crossAxisAlignment,
            children: [
              // flex 2:1:1: thẻ đầu được chia gấp đôi mỗi thẻ còn lại.
              _wrapCard(
                const _StatCard(
                  icon: Icons.bed,
                  value: '128',
                  label: 'Phòng',
                  note: 'Còn 3 trống',
                ),
                2,
              ),
              _wrapCard(
                const _StatCard(
                  icon: Icons.square_foot,
                  value: '45 m²',
                  label: 'Diện tích',
                ),
                1,
              ),
              _wrapCard(
                const _StatCard(
                  icon: Icons.star_outline,
                  value: '4.8',
                  label: 'Đánh giá',
                ),
                1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AxisLegend extends StatelessWidget {
  const _AxisLegend();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall;
    // Wrap: chú thích tự xuống dòng nên không gây tràn ở khung hẹp.
    return Wrap(
      spacing: 12,
      children: [
        Text('Đỏ: main axis (ngang)', style: style?.copyWith(color: Colors.red)),
        Text(
          'Xanh: cross axis (dọc)',
          style: style?.copyWith(color: Colors.blue),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    this.note,
  });

  final IconData icon;
  final String value;
  final String label;

  /// Dòng phụ làm thẻ này cao hơn 2 thẻ kia, để thấy khác biệt trên cross axis.
  final String? note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: colors.primary),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall,
          ),
          if (note != null)
            Text(
              note!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(color: colors.error),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TIỆN ÍCH
// ---------------------------------------------------------------------------

class AmenitiesSection extends StatelessWidget {
  const AmenitiesSection({super.key, required this.config});

  final LabConfig config;

  @override
  Widget build(BuildContext context) {
    final chips = [
      for (final (icon, label) in buildAmenities(config.extraAmenities))
        Chip(
          avatar: Icon(icon, size: 16),
          label: Text(label),
          visualDensity: VisualDensity.compact,
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tiện ích',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        config.handleOverflow
            // Wrap: hết chỗ trên dòng hiện tại thì tự đưa con xuống dòng mới.
            // spacing là khoảng cách ngang, runSpacing là khoảng cách giữa dòng.
            ? Wrap(spacing: 8, runSpacing: 8, children: chips)
            // Row không bao giờ xuống dòng: thêm tiện ích là tràn khung.
            : Row(children: chips),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// MÔ TẢ
// ---------------------------------------------------------------------------

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({
    super.key,
    required this.isExpanded,
    required this.onToggle,
  });

  final bool isExpanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mô tả',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        // maxLines = null: không giới hạn số dòng, hiện toàn bộ nội dung.
        Text(
          kHotelDescription,
          maxLines: isExpanded ? null : 3,
          overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
        ),
        TextButton(
          onPressed: onToggle,
          child: Text(isExpanded ? 'Thu gọn' : 'Xem thêm'),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// THANH ĐẶT PHÒNG
// ---------------------------------------------------------------------------

class BookingBar extends StatelessWidget {
  const BookingBar({
    super.key,
    required this.handleOverflow,
    required this.onBook,
  });

  /// Chiều rộng cố định của nút ở chế độ Row thường.
  static const double fixedButtonWidth = 200;

  final bool handleOverflow;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final button = FilledButton(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      onPressed: onBook,
      child: const Text(
        'Đặt phòng',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        // Phần Flexible loose không dùng hết sẽ KHÔNG được chuyển cho Expanded,
        // nên dùng spaceBetween để đẩy chỗ dư vào giữa, nút nằm sát lề phải.
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: handleOverflow
            ? [
                // Flexible: giá tiền ngắn thì chỉ rộng vừa đủ, khung hẹp thì co
                // lại và cắt bằng ellipsis.
                const Flexible(child: _PriceLabel(handleOverflow: true)),
                const SizedBox(width: 12),
                // Expanded: nút luôn lấp đầy toàn bộ phần được chia theo flex.
                Expanded(child: button),
              ]
            : [
                // Row thường: giá + nút rộng cố định, khung hẹp sẽ tràn.
                const _PriceLabel(handleOverflow: false),
                const SizedBox(width: 12),
                SizedBox(width: fixedButtonWidth, child: button),
              ],
      ),
    );
  }
}

class _PriceLabel extends StatelessWidget {
  const _PriceLabel({required this.handleOverflow});

  final bool handleOverflow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxLines = handleOverflow ? 1 : null;
    final overflow = handleOverflow ? TextOverflow.ellipsis : null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2.400.000đ',
          maxLines: maxLines,
          overflow: overflow,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text.rich(
          const TextSpan(
            children: [
              TextSpan(
                text: '3.000.000đ',
                style: TextStyle(decoration: TextDecoration.lineThrough),
              ),
              TextSpan(text: ' / đêm'),
            ],
          ),
          maxLines: maxLines,
          overflow: overflow,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// BẢNG ĐIỀU KHIỂN LAYOUT LAB
// ---------------------------------------------------------------------------

class LayoutLabPanel extends StatelessWidget {
  const LayoutLabPanel({
    super.key,
    required this.config,
    required this.onChanged,
  });

  /// Các giá trị của CrossAxisAlignment dùng được cho hàng thống kê.
  /// Không có baseline vì giá trị này bắt buộc phải khai báo textBaseline.
  static const List<CrossAxisAlignment> crossOptions = [
    CrossAxisAlignment.start,
    CrossAxisAlignment.center,
    CrossAxisAlignment.end,
    CrossAxisAlignment.stretch,
  ];

  final LabConfig config;

  // Widget con không tự giữ trạng thái: chỉ báo cấu hình mới lên cho cha.
  final ValueChanged<LabConfig> onChanged;

  String get _flexHint {
    if (!config.handleOverflow) {
      return 'Đang dùng Row thường với thẻ rộng cố định, lựa chọn này tạm tắt.';
    }
    return config.flexMode == FlexDemoMode.expanded
        ? 'Expanded chiếm hết chỗ trống nên MainAxisAlignment không đổi gì. '
              'Chọn Flexible để thấy khác biệt.'
        : 'Thẻ chỉ rộng vừa nội dung, chỗ trống còn lại được phân bổ theo '
              'MainAxisAlignment.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Layout Lab',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () => onChanged(const LabConfig()),
              icon: const Icon(Icons.restart_alt),
              label: const Text('Đặt lại'),
            ),
          ],
        ),
        const _LabHeading('Chiều rộng khung xem trước'),
        Text(
          '${config.previewWidth.round()} px · '
          '${config.isTwoColumn ? '2 cột (LayoutBuilder > 600px)' : '1 cột'}',
          style: theme.textTheme.bodySmall,
        ),
        Slider(
          min: kMinPreviewWidth,
          max: kMaxPreviewWidth,
          divisions: 66,
          value: config.previewWidth,
          label: '${config.previewWidth.round()} px',
          onChanged: (value) => onChanged(config.copyWith(previewWidth: value)),
        ),
        const _LabHeading('Căn chỉnh hàng thống kê'),
        _DropdownField<MainAxisAlignment>(
          label: 'MainAxisAlignment (đỏ)',
          value: config.mainAxisAlignment,
          options: MainAxisAlignment.values,
          optionLabel: (option) => option.name,
          onChanged: (value) =>
              onChanged(config.copyWith(mainAxisAlignment: value)),
        ),
        _DropdownField<CrossAxisAlignment>(
          label: 'CrossAxisAlignment (xanh)',
          value: config.crossAxisAlignment,
          options: crossOptions,
          optionLabel: (option) => option.name,
          onChanged: (value) =>
              onChanged(config.copyWith(crossAxisAlignment: value)),
        ),
        const _LabHeading('Flexible loose và Expanded'),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<FlexDemoMode>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: FlexDemoMode.flexibleLoose,
                label: Text('Flexible (loose)'),
              ),
              ButtonSegment(
                value: FlexDemoMode.expanded,
                label: Text('Expanded'),
              ),
            ],
            selected: {config.flexMode},
            // onSelectionChanged = null: SegmentedButton chuyển sang trạng thái
            // vô hiệu hóa, vì khi tắt xử lý overflow hàng này là Row thường.
            onSelectionChanged: config.handleOverflow
                ? (selection) =>
                      onChanged(config.copyWith(flexMode: selection.first))
                : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(_flexHint, style: theme.textTheme.bodySmall),
        const _LabHeading('Tăng nội dung'),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Tên khách sạn siêu dài'),
          value: config.useLongName,
          onChanged: (value) => onChanged(config.copyWith(useLongName: value)),
        ),
        OutlinedButton(
          onPressed: () => onChanged(
            config.copyWith(extraAmenities: config.extraAmenities + 1),
          ),
          child: Text(
            '+ Thêm tiện ích (${buildAmenities(config.extraAmenities).length})',
          ),
        ),
        const _LabHeading('Xử lý overflow'),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Bật xử lý overflow'),
          subtitle: const Text(
            'Tắt: dùng Row, Column thường và thấy vạch sọc vàng-đen '
            '(chỉ hiện ở debug mode).\n'
            'Bật: dùng Expanded, Wrap, ellipsis, SingleChildScrollView.',
          ),
          value: config.handleOverflow,
          onChanged: (value) =>
              onChanged(config.copyWith(handleOverflow: value)),
        ),
      ],
    );
  }
}

class _LabHeading extends StatelessWidget {
  const _LabHeading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.options,
    required this.optionLabel,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> options;
  final String Function(T option) optionLabel;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        // isExpanded: dropdown rộng bằng cha, tên dài không làm tràn hàng.
        DropdownButton<T>(
          isExpanded: true,
          value: value,
          items: [
            for (final option in options)
              DropdownMenuItem(value: option, child: Text(optionLabel(option))),
          ],
          onChanged: (selected) {
            if (selected != null) onChanged(selected);
          },
        ),
      ],
    );
  }
}
