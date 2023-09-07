import 'package:flutter/material.dart';

class CustomBottomNavTheme extends ThemeExtension<CustomBottomNavTheme> {
  const CustomBottomNavTheme({
    required this.bottomNavigationBarBackgroundColor,
    required this.activeNavigationBarColor,
    required this.notActiveNavigationBarColor,
  });

  final Color bottomNavigationBarBackgroundColor;
  final Color activeNavigationBarColor;
  final Color notActiveNavigationBarColor;

  @override
  CustomBottomNavTheme copyWith({
    Color? bottomNavigationBarBackgroundColor,
    Color? activeNavigationBarColor,
    Color? notActiveNavigationBarColor,
  }) {
    return CustomBottomNavTheme(
      bottomNavigationBarBackgroundColor: bottomNavigationBarBackgroundColor ??
          this.bottomNavigationBarBackgroundColor,
      activeNavigationBarColor:
          activeNavigationBarColor ?? this.activeNavigationBarColor,
      notActiveNavigationBarColor:
          notActiveNavigationBarColor ?? this.notActiveNavigationBarColor,
    );
  }

  @override
  CustomBottomNavTheme lerp(
    ThemeExtension<CustomBottomNavTheme>? other,
    double t,
  ) {
    if (other is! CustomBottomNavTheme) {
      return this;
    }
    return CustomBottomNavTheme(
      bottomNavigationBarBackgroundColor: Color.lerp(
              bottomNavigationBarBackgroundColor,
              other.bottomNavigationBarBackgroundColor,
              t) ??
          bottomNavigationBarBackgroundColor,
      activeNavigationBarColor: Color.lerp(
              activeNavigationBarColor, other.activeNavigationBarColor, t) ??
          activeNavigationBarColor,
      notActiveNavigationBarColor: Color.lerp(notActiveNavigationBarColor,
              other.notActiveNavigationBarColor, t) ??
          notActiveNavigationBarColor,
    );
  }
}
