import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Defines visual decoration parameters for a seat under a particular status or type.
@immutable
class SeatStyle extends Equatable {
  /// Background fill color.
  final Color backgroundColor;

  /// Optional background gradient override.
  final Gradient? backgroundGradient;

  /// Foreground/label text color.
  final Color foregroundColor;

  /// Border color of the seat.
  final Color borderColor;

  /// Border width.
  final double borderWidth;

  /// Corner radius for the seat shape.
  final BorderRadius borderRadius;

  /// Shadow effect underneath the seat.
  final List<BoxShadow>? shadows;

  /// Text style for seat label.
  final TextStyle? textStyle;

  /// Optional accent indicator color (e.g., pillow or armrest accent).
  final Color? accentColor;

  const SeatStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor = Colors.transparent,
    this.borderWidth = 1.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.backgroundGradient,
    this.shadows,
    this.textStyle,
    this.accentColor,
  });

  /// Copies this [SeatStyle] with specified parameters overwritten.
  SeatStyle copyWith({
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Color? foregroundColor,
    Color? borderColor,
    double? borderWidth,
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
    TextStyle? textStyle,
    Color? accentColor,
  }) {
    return SeatStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      shadows: shadows ?? this.shadows,
      textStyle: textStyle ?? this.textStyle,
      accentColor: accentColor ?? this.accentColor,
    );
  }

  @override
  List<Object?> get props => [
        backgroundColor,
        backgroundGradient,
        foregroundColor,
        borderColor,
        borderWidth,
        borderRadius,
        shadows,
        textStyle,
        accentColor,
      ];
}
