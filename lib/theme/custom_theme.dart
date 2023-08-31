import 'package:flutter/material.dart';

class CustomTheme extends ThemeExtension<CustomTheme> {
  const CustomTheme({
    required this.bottomNavigationBarBackgroundColor,
    required this.colorLabelColor,
    required this.activeNavigationBarColor,
    required this.notActiveNavigationBarColor,
    required this.shadowNavigationBarColor,
  });

  final Color bottomNavigationBarBackgroundColor;
  final Color colorLabelColor;
  final Color activeNavigationBarColor;
  final Color notActiveNavigationBarColor;
  final Color shadowNavigationBarColor;

  @override
  CustomTheme copyWith({
    Color? bottomNavigationBarBackgroundColor,
    Color? colorLabelColor,
    Color? activeNavigationBarColor,
    Color? notActiveNavigationBarColor,
    Color? shadowNavigationBarColor,
  }) {
    return CustomTheme(
      bottomNavigationBarBackgroundColor: bottomNavigationBarBackgroundColor ??
          this.bottomNavigationBarBackgroundColor,
      colorLabelColor: colorLabelColor ?? this.colorLabelColor,
      activeNavigationBarColor:
          activeNavigationBarColor ?? this.activeNavigationBarColor,
      notActiveNavigationBarColor:
          notActiveNavigationBarColor ?? this.notActiveNavigationBarColor,
      shadowNavigationBarColor:
          shadowNavigationBarColor ?? this.shadowNavigationBarColor,
    );
  }

  @override
  CustomTheme lerp(
    ThemeExtension<CustomTheme>? other,
    double t,
  ) {
    if (other is! CustomTheme) {
      return this;
    }
    return CustomTheme(
      bottomNavigationBarBackgroundColor: Color.lerp(
              bottomNavigationBarBackgroundColor,
              other.bottomNavigationBarBackgroundColor,
              t) ??
          bottomNavigationBarBackgroundColor,
      colorLabelColor: Color.lerp(colorLabelColor, other.colorLabelColor, t) ??
          colorLabelColor,
      activeNavigationBarColor: Color.lerp(
              activeNavigationBarColor, other.activeNavigationBarColor, t) ??
          activeNavigationBarColor,
      notActiveNavigationBarColor: Color.lerp(notActiveNavigationBarColor,
              other.notActiveNavigationBarColor, t) ??
          notActiveNavigationBarColor,
      shadowNavigationBarColor: Color.lerp(
              shadowNavigationBarColor, other.shadowNavigationBarColor, t) ??
          shadowNavigationBarColor,
    );
  }
}
