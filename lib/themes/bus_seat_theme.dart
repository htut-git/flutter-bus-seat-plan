import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../models/seat.dart';
import 'seat_style.dart';

/// Complete theme configuration for the bus seat plan layout and elements.
@immutable
class BusSeatThemeData extends Equatable {
  /// Overall background color of the seat plan container.
  final Color backgroundColor;

  /// Bus body/chassis background fill color.
  final Color busBodyColor;

  /// Bus chassis border / outline color.
  final Color busBorderColor;

  /// Steering wheel / driver icon color.
  final Color steeringWheelColor;

  /// Driver cabin area background color.
  final Color driverCabinColor;

  /// Standard seat width in logical pixels.
  final double seatWidth;

  /// Standard seat height in logical pixels.
  final double seatHeight;

  /// Sleeper berth width in logical pixels.
  final double sleeperWidth;

  /// Sleeper berth height in logical pixels.
  final double sleeperHeight;

  /// Gap between adjacent seats in the same row.
  final double seatGap;

  /// Gap between consecutive rows.
  final double rowGap;

  /// Extra gap/spacing used for aisle columns.
  final double aisleGap;

  /// Padding around the inner bus chassis.
  final EdgeInsets chassisPadding;

  /// Whether to render the realistic outer bus chassis outline with windshield & mirrors.
  final bool showBusFrame;

  /// Whether to display the driver cabin widget.
  final bool showDriverArea;

  /// Whether to show the legend at the bottom/top.
  final bool showLegend;

  /// Whether to display alphanumeric seat numbers inside seats.
  final bool showSeatNumbers;

  /// Whether to use detailed vector CustomPainter for seats.
  final bool useVectorSeats;

  /// Style for available standard seats.
  final SeatStyle availableStyle;

  /// Style for currently selected seats.
  final SeatStyle selectedStyle;

  /// Style for booked/sold seats.
  final SeatStyle bookedStyle;

  /// Style for reserved/held seats.
  final SeatStyle reservedStyle;

  /// Style for disabled/blocked seats.
  final SeatStyle disabledStyle;

  /// Style for female-only seats.
  final SeatStyle femaleOnlyStyle;

  /// Style override for VIP available seats.
  final SeatStyle? vipAvailableStyle;

  /// Style override for Sleeper available seats.
  final SeatStyle? sleeperAvailableStyle;

  /// Text style for deck selector tabs.
  final TextStyle? deckTabTextStyle;

  /// Text style for legend labels.
  final TextStyle? legendTextStyle;

  const BusSeatThemeData({
    required this.backgroundColor,
    required this.busBodyColor,
    required this.busBorderColor,
    required this.steeringWheelColor,
    required this.driverCabinColor,
    required this.availableStyle,
    required this.selectedStyle,
    required this.bookedStyle,
    required this.reservedStyle,
    required this.disabledStyle,
    required this.femaleOnlyStyle,
    this.vipAvailableStyle,
    this.sleeperAvailableStyle,
    this.seatWidth = 46.0,
    this.seatHeight = 46.0,
    this.sleeperWidth = 52.0,
    this.sleeperHeight = 88.0,
    this.seatGap = 8.0,
    this.rowGap = 8.0,
    this.aisleGap = 24.0,
    this.chassisPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    this.showBusFrame = true,
    this.showDriverArea = true,
    this.showLegend = true,
    this.showSeatNumbers = true,
    this.useVectorSeats = true,
    this.deckTabTextStyle,
    this.legendTextStyle,
  });

  /// Light theme preset with clean, modern, high-contrast colors.
  factory BusSeatThemeData.light() {
    return const BusSeatThemeData(
      backgroundColor: Color(0xFFF9FAFB),
      busBodyColor: Color(0xFFFFFFFF),
      busBorderColor: Color(0xFFE5E7EB),
      steeringWheelColor: Color(0xFF6B7280),
      driverCabinColor: Color(0xFFF3F4F6),
      seatWidth: 46.0,
      seatHeight: 46.0,
      sleeperWidth: 52.0,
      sleeperHeight: 88.0,
      seatGap: 8.0,
      rowGap: 8.0,
      aisleGap: 24.0,
      availableStyle: SeatStyle(
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Color(0xFF1F2937),
        borderColor: Color(0xFFD1D5DB),
        borderWidth: 1.5,
        accentColor: Color(0xFF9CA3AF),
      ),
      selectedStyle: SeatStyle(
        backgroundColor: Color(0xFF2563EB),
        foregroundColor: Color(0xFFFFFFFF),
        borderColor: Color(0xFF1D4ED8),
        borderWidth: 2.0,
        accentColor: Color(0xFF93C5FD),
      ),
      bookedStyle: SeatStyle(
        backgroundColor: Color(0xFFE5E7EB),
        foregroundColor: Color(0xFF9CA3AF),
        borderColor: Color(0xFFD1D5DB),
        borderWidth: 1.0,
        accentColor: Color(0xFFD1D5DB),
      ),
      reservedStyle: SeatStyle(
        backgroundColor: Color(0xFFFEF3C7),
        foregroundColor: Color(0xFFB45309),
        borderColor: Color(0xFFFCD34D),
        borderWidth: 1.5,
        accentColor: Color(0xFFF59E0B),
      ),
      disabledStyle: SeatStyle(
        backgroundColor: Color(0xFFF3F4F6),
        foregroundColor: Color(0xFFD1D5DB),
        borderColor: Color(0xFFE5E7EB),
        borderWidth: 1.0,
      ),
      femaleOnlyStyle: SeatStyle(
        backgroundColor: Color(0xFFFDF2F8),
        foregroundColor: Color(0xFFDB2777),
        borderColor: Color(0xFFFBCFE8),
        borderWidth: 1.5,
        accentColor: Color(0xFFF472B6),
      ),
      vipAvailableStyle: SeatStyle(
        backgroundColor: Color(0xFFFFFBEB),
        foregroundColor: Color(0xFF92400E),
        borderColor: Color(0xFFFDE68A),
        borderWidth: 1.5,
        accentColor: Color(0xFFF59E0B),
      ),
      sleeperAvailableStyle: SeatStyle(
        backgroundColor: Color(0xFFF0FDF4),
        foregroundColor: Color(0xFF166534),
        borderColor: Color(0xFFBBF7D0),
        borderWidth: 1.5,
        accentColor: Color(0xFF4ADE80),
      ),
    );
  }

  /// Dark theme preset with sleek slate aesthetics.
  factory BusSeatThemeData.dark() {
    return const BusSeatThemeData(
      backgroundColor: Color(0xFF0F172A),
      busBodyColor: Color(0xFF1E293B),
      busBorderColor: Color(0xFF334155),
      steeringWheelColor: Color(0xFF94A3B8),
      driverCabinColor: Color(0xFF0F172A),
      seatWidth: 46.0,
      seatHeight: 46.0,
      sleeperWidth: 52.0,
      sleeperHeight: 88.0,
      seatGap: 8.0,
      rowGap: 8.0,
      aisleGap: 24.0,
      availableStyle: SeatStyle(
        backgroundColor: Color(0xFF334155),
        foregroundColor: Color(0xFFF8FAFC),
        borderColor: Color(0xFF475569),
        borderWidth: 1.5,
        accentColor: Color(0xFF64748B),
      ),
      selectedStyle: SeatStyle(
        backgroundColor: Color(0xFF3B82F6),
        foregroundColor: Color(0xFFFFFFFF),
        borderColor: Color(0xFF60A5FA),
        borderWidth: 2.0,
        accentColor: Color(0xFF93C5FD),
      ),
      bookedStyle: SeatStyle(
        backgroundColor: Color(0xFF1E293B),
        foregroundColor: Color(0xFF64748B),
        borderColor: Color(0xFF334155),
        borderWidth: 1.0,
      ),
      reservedStyle: SeatStyle(
        backgroundColor: Color(0xFF78350F),
        foregroundColor: Color(0xFFFDE68A),
        borderColor: Color(0xFF92400E),
        borderWidth: 1.5,
      ),
      disabledStyle: SeatStyle(
        backgroundColor: Color(0xFF18202F),
        foregroundColor: Color(0xFF475569),
        borderColor: Color(0xFF1E293B),
        borderWidth: 1.0,
      ),
      femaleOnlyStyle: SeatStyle(
        backgroundColor: Color(0xFF831843),
        foregroundColor: Color(0xFFFDF2F8),
        borderColor: Color(0xFFBE185D),
        borderWidth: 1.5,
      ),
      vipAvailableStyle: SeatStyle(
        backgroundColor: Color(0xFF451A03),
        foregroundColor: Color(0xFFFDE68A),
        borderColor: Color(0xFFB45309),
        borderWidth: 1.5,
      ),
      sleeperAvailableStyle: SeatStyle(
        backgroundColor: Color(0xFF064E3B),
        foregroundColor: Color(0xFFD1FAE5),
        borderColor: Color(0xFF059669),
        borderWidth: 1.5,
      ),
    );
  }

  /// Luxury preset with clean gold & navy accents.
  factory BusSeatThemeData.luxury() {
    return const BusSeatThemeData(
      backgroundColor: Color(0xFF0B132B),
      busBodyColor: Color(0xFF1C2541),
      busBorderColor: Color(0xFF3A506B),
      steeringWheelColor: Color(0xFFD4AF37),
      driverCabinColor: Color(0xFF0B132B),
      seatWidth: 48.0,
      seatHeight: 48.0,
      sleeperWidth: 54.0,
      sleeperHeight: 90.0,
      seatGap: 8.0,
      rowGap: 9.0,
      aisleGap: 24.0,
      availableStyle: SeatStyle(
        backgroundColor: Color(0xFF1C2541),
        foregroundColor: Color(0xFFE0E1DD),
        borderColor: Color(0xFF3A506B),
        borderWidth: 1.5,
        accentColor: Color(0xFF5BC0BE),
      ),
      selectedStyle: SeatStyle(
        backgroundColor: Color(0xFFD4AF37),
        foregroundColor: Color(0xFF0B132B),
        borderColor: Color(0xFFFFD700),
        borderWidth: 2.0,
        accentColor: Color(0xFFFFF4B8),
      ),
      bookedStyle: SeatStyle(
        backgroundColor: Color(0xFF141D33),
        foregroundColor: Color(0xFF4A5568),
        borderColor: Color(0xFF23314F),
        borderWidth: 1.0,
      ),
      reservedStyle: SeatStyle(
        backgroundColor: Color(0xFF4A3B18),
        foregroundColor: Color(0xFFFFE599),
        borderColor: Color(0xFF8C6D23),
        borderWidth: 1.5,
      ),
      disabledStyle: SeatStyle(
        backgroundColor: Color(0xFF0E1626),
        foregroundColor: Color(0xFF3A4750),
        borderColor: Color(0xFF1C2541),
        borderWidth: 1.0,
      ),
      femaleOnlyStyle: SeatStyle(
        backgroundColor: Color(0xFF4A152E),
        foregroundColor: Color(0xFFFFC0D9),
        borderColor: Color(0xFF8F2D56),
        borderWidth: 1.5,
      ),
      vipAvailableStyle: SeatStyle(
        backgroundColor: Color(0xFF241D3B),
        foregroundColor: Color(0xFFFFD700),
        borderColor: Color(0xFF9E7B35),
        borderWidth: 1.8,
      ),
    );
  }

  /// Emerald theme with fresh clean green accents.
  factory BusSeatThemeData.emerald() {
    return const BusSeatThemeData(
      backgroundColor: Color(0xFFF0FDF4),
      busBodyColor: Color(0xFFFFFFFF),
      busBorderColor: Color(0xFFDCFCE7),
      steeringWheelColor: Color(0xFF15803D),
      driverCabinColor: Color(0xFFDCFCE7),
      seatWidth: 46.0,
      seatHeight: 46.0,
      availableStyle: SeatStyle(
        backgroundColor: Color(0xFFFFFFFF),
        foregroundColor: Color(0xFF14532D),
        borderColor: Color(0xFF86EFAC),
        borderWidth: 1.5,
        accentColor: Color(0xFF4ADE80),
      ),
      selectedStyle: SeatStyle(
        backgroundColor: Color(0xFF16A34A),
        foregroundColor: Color(0xFFFFFFFF),
        borderColor: Color(0xFF15803D),
        borderWidth: 2.0,
        accentColor: Color(0xFF86EFAC),
      ),
      bookedStyle: SeatStyle(
        backgroundColor: Color(0xFFE2E8F0),
        foregroundColor: Color(0xFF94A3B8),
        borderColor: Color(0xFFCBD5E1),
      ),
      reservedStyle: SeatStyle(
        backgroundColor: Color(0xFFFEF3C7),
        foregroundColor: Color(0xFFB45309),
        borderColor: Color(0xFFFDE68A),
      ),
      disabledStyle: SeatStyle(
        backgroundColor: Color(0xFFF1F5F9),
        foregroundColor: Color(0xFFCBD5E1),
        borderColor: Color(0xFFE2E8F0),
      ),
      femaleOnlyStyle: SeatStyle(
        backgroundColor: Color(0xFFFDF2F8),
        foregroundColor: Color(0xFFDB2777),
        borderColor: Color(0xFFFBCFE8),
      ),
    );
  }

  /// Copies this [BusSeatThemeData] with specified parameters overwritten.
  BusSeatThemeData copyWith({
    Color? backgroundColor,
    Color? busBodyColor,
    Color? busBorderColor,
    Color? steeringWheelColor,
    Color? driverCabinColor,
    double? seatWidth,
    double? seatHeight,
    double? sleeperWidth,
    double? sleeperHeight,
    double? seatGap,
    double? rowGap,
    double? aisleGap,
    EdgeInsets? chassisPadding,
    bool? showBusFrame,
    bool? showDriverArea,
    bool? showLegend,
    bool? showSeatNumbers,
    bool? useVectorSeats,
    SeatStyle? availableStyle,
    SeatStyle? selectedStyle,
    SeatStyle? bookedStyle,
    SeatStyle? reservedStyle,
    SeatStyle? disabledStyle,
    SeatStyle? femaleOnlyStyle,
    SeatStyle? vipAvailableStyle,
    SeatStyle? sleeperAvailableStyle,
    TextStyle? deckTabTextStyle,
    TextStyle? legendTextStyle,
  }) {
    return BusSeatThemeData(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      busBodyColor: busBodyColor ?? this.busBodyColor,
      busBorderColor: busBorderColor ?? this.busBorderColor,
      steeringWheelColor: steeringWheelColor ?? this.steeringWheelColor,
      driverCabinColor: driverCabinColor ?? this.driverCabinColor,
      seatWidth: seatWidth ?? this.seatWidth,
      seatHeight: seatHeight ?? this.seatHeight,
      sleeperWidth: sleeperWidth ?? this.sleeperWidth,
      sleeperHeight: sleeperHeight ?? this.sleeperHeight,
      seatGap: seatGap ?? this.seatGap,
      rowGap: rowGap ?? this.rowGap,
      aisleGap: aisleGap ?? this.aisleGap,
      chassisPadding: chassisPadding ?? this.chassisPadding,
      showBusFrame: showBusFrame ?? this.showBusFrame,
      showDriverArea: showDriverArea ?? this.showDriverArea,
      showLegend: showLegend ?? this.showLegend,
      showSeatNumbers: showSeatNumbers ?? this.showSeatNumbers,
      useVectorSeats: useVectorSeats ?? this.useVectorSeats,
      availableStyle: availableStyle ?? this.availableStyle,
      selectedStyle: selectedStyle ?? this.selectedStyle,
      bookedStyle: bookedStyle ?? this.bookedStyle,
      reservedStyle: reservedStyle ?? this.reservedStyle,
      disabledStyle: disabledStyle ?? this.disabledStyle,
      femaleOnlyStyle: femaleOnlyStyle ?? this.femaleOnlyStyle,
      vipAvailableStyle: vipAvailableStyle ?? this.vipAvailableStyle,
      sleeperAvailableStyle: sleeperAvailableStyle ?? this.sleeperAvailableStyle,
      deckTabTextStyle: deckTabTextStyle ?? this.deckTabTextStyle,
      legendTextStyle: legendTextStyle ?? this.legendTextStyle,
    );
  }

  /// Resolves the corresponding [SeatStyle] for a specific seat given its effective status.
  SeatStyle styleForSeat(Seat seat, SeatStatus effectiveStatus) {
    switch (effectiveStatus) {
      case SeatStatus.selected:
        return selectedStyle;
      case SeatStatus.booked:
        return bookedStyle;
      case SeatStatus.reserved:
        return reservedStyle;
      case SeatStatus.disabled:
        return disabledStyle;
      case SeatStatus.femaleOnly:
        return femaleOnlyStyle;
      case SeatStatus.available:
        if (seat.type == SeatType.vip && vipAvailableStyle != null) {
          return vipAvailableStyle!;
        }
        if (seat.type == SeatType.sleeper && sleeperAvailableStyle != null) {
          return sleeperAvailableStyle!;
        }
        return availableStyle;
    }
  }

  @override
  List<Object?> get props => [
        backgroundColor,
        busBodyColor,
        busBorderColor,
        steeringWheelColor,
        driverCabinColor,
        seatWidth,
        seatHeight,
        sleeperWidth,
        sleeperHeight,
        seatGap,
        rowGap,
        aisleGap,
        chassisPadding,
        showBusFrame,
        showDriverArea,
        showLegend,
        showSeatNumbers,
        useVectorSeats,
        availableStyle,
        selectedStyle,
        bookedStyle,
        reservedStyle,
        disabledStyle,
        femaleOnlyStyle,
        vipAvailableStyle,
        sleeperAvailableStyle,
      ];
}
