import 'package:flutter/material.dart';

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
          Text('4.8', style: theme.textTheme.titleLarge),
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
