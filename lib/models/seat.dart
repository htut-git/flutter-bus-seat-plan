import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

/// Status of a bus seat indicating its availability and booking condition.
enum SeatStatus {
  /// Available for booking/selection
  available,

  /// Currently selected by the user
  selected,

  /// Already booked / purchased
  booked,

  /// Temporarily reserved / held
  reserved,

  /// Disabled / blocked / out of service
  disabled,

  /// Reserved exclusively for female passengers
  femaleOnly,
}

/// Physical or luxury classification of a seat.
enum SeatType {
  /// Standard bus seat
  standard,

  /// Semi-sleeper / recliner seat
  semiSleeper,

  /// Full lie-flat sleeper berth or bunk
  sleeper,

  /// VIP / Executive / First-class seat with extra amenities
  vip,
}

/// Position of the driver cabin relative to the passenger rows.
enum DriverPosition {
  /// Driver cabin on the front left (standard for left-hand drive countries)
  left,

  /// Driver cabin on the front right (standard for right-hand drive countries)
  right,

  /// Driver cabin centered
  center,

  /// No driver cabin displayed
  none,
}

/// Represents a single seat in a bus layout.
@immutable
class Seat extends Equatable {
  /// Unique identifier for this seat (e.g., "1_1", "L_1A").
  final String id;

  /// Display text or seat number shown to users (e.g., "1A", "UB-4", "12").
  final String label;

  /// Grid row index (0-based).
  final int row;

  /// Grid column index (0-based).
  final int column;

  /// Deck or floor index (0 for single/lower deck, 1 for upper deck).
  final int deckIndex;

  /// Current status of the seat.
  final SeatStatus status;

  /// Classification type of the seat.
  final SeatType type;

  /// Optional price of this specific seat.
  final double? price;

  /// Optional passenger gender note or reservation note.
  final String? passengerInfo;

  /// Custom arbitrary payload/metadata attached to this seat.
  final dynamic customData;

  /// Optional custom icon override.
  final Widget? icon;

  const Seat({
    required this.id,
    required this.label,
    this.row = 0,
    this.column = 0,
    this.deckIndex = 0,
    this.status = SeatStatus.available,
    this.type = SeatType.standard,
    this.price,
    this.passengerInfo,
    this.customData,
    this.icon,
  });

  /// Whether the seat can be tapped/selected by a customer.
  bool get isSelectable =>
      status == SeatStatus.available ||
      status == SeatStatus.selected ||
      status == SeatStatus.femaleOnly;

  /// Whether the seat is currently selected.
  bool get isSelected => status == SeatStatus.selected;

  /// Whether the seat is already occupied or unavailable.
  bool get isOccupied =>
      status == SeatStatus.booked ||
      status == SeatStatus.reserved ||
      status == SeatStatus.disabled;

  /// Creates a copy of this seat with specified fields updated.
  Seat copyWith({
    String? id,
    String? label,
    int? row,
    int? column,
    int? deckIndex,
    SeatStatus? status,
    SeatType? type,
    double? price,
    String? passengerInfo,
    dynamic customData,
    Widget? icon,
    bool clearIcon = false,
  }) {
    return Seat(
      id: id ?? this.id,
      label: label ?? this.label,
      row: row ?? this.row,
      column: column ?? this.column,
      deckIndex: deckIndex ?? this.deckIndex,
      status: status ?? this.status,
      type: type ?? this.type,
      price: price ?? this.price,
      passengerInfo: passengerInfo ?? this.passengerInfo,
      customData: customData ?? this.customData,
      icon: clearIcon ? null : (icon ?? this.icon),
    );
  }

  @override
  List<Object?> get props => [
        id,
        label,
        row,
        column,
        deckIndex,
        status,
        type,
        price,
        passengerInfo,
        customData,
      ];
}
