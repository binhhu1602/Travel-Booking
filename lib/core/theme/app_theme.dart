import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData buildAppTheme() {
  // Material 3: fromSeed sinh màu ngả xám, nên ghi đè các màu chính để có nền
  // trắng và xanh dương tươi như đa số ứng dụng đặt phòng.
  final colorScheme = ColorScheme.fromSeed(seedColor: kBrandBlue).copyWith(
    primary: kBrandBlue,
    onPrimary: Colors.white,
    primaryContainer: kBrandBlueLight,
    onPrimaryContainer: const Color(0xFF0B4FB3),
    secondaryContainer: kBrandBlueLight,
    onSecondaryContainer: const Color(0xFF0B4FB3),
    surface: Colors.white,
    onSurface: kTextPrimary,
    onSurfaceVariant: kTextSecondary,
    surfaceContainer: Colors.white,
    surfaceContainerLow: kPageGrey,
    outline: const Color(0xFF9CA3AF),
    outlineVariant: kBorderGrey,
    error: const Color(0xFFE53935),
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    // Cỡ chữ tập trung một chỗ, letterSpacing = 0 cho chữ tiếng Việt gọn hơn.
    // ThemeData trộn các giá trị này vào kiểu mặc định của Material.
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 0,
      ),
      bodyLarge: TextStyle(fontSize: 15, height: 1.4, letterSpacing: 0),
      bodyMedium: TextStyle(fontSize: 14, height: 1.45, letterSpacing: 0),
      bodySmall: TextStyle(
        fontSize: 12,
        height: 1.35,
        letterSpacing: 0,
        color: kTextSecondary,
      ),
      labelLarge: TextStyle(fontSize: 14, letterSpacing: 0),
      labelSmall: TextStyle(fontSize: 11, letterSpacing: 0),
    ),
  );

  // Nút và chip lấy kiểu chữ từ base.textTheme để giữ nguyên font của theme.
  return base.copyWith(
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 48),
        textStyle: base.textTheme.labelLarge?.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      side: const BorderSide(color: kBorderGrey),
      labelStyle: base.textTheme.bodySmall?.copyWith(
        fontSize: 13,
        color: kTextPrimary,
      ),
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
  );
}
