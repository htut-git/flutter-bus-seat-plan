import '../models/seat.dart';
import '../models/seat_layout.dart';

/// Extension methods for [SeatLayout] providing quick querying and counting utilities.
extension SeatLayoutX on SeatLayout {
  /// All available seats across all decks.
  List<Seat> get availableSeats =>
      allSeats.where((s) => s.status == SeatStatus.available).toList();

  /// All booked/sold seats across all decks.
  List<Seat> get bookedSeats =>
      allSeats.where((s) => s.status == SeatStatus.booked).toList();

  /// All reserved seats across all decks.
  List<Seat> get reservedSeats =>
      allSeats.where((s) => s.status == SeatStatus.reserved).toList();

  /// All disabled seats across all decks.
  List<Seat> get disabledSeats =>
      allSeats.where((s) => s.status == SeatStatus.disabled).toList();

  /// All female-only seats across all decks.
  List<Seat> get femaleOnlySeats =>
      allSeats.where((s) => s.status == SeatStatus.femaleOnly).toList();

  /// All VIP classification seats across all decks.
  List<Seat> get vipSeats =>
      allSeats.where((s) => s.type == SeatType.vip).toList();

  /// All sleeper classification berths across all decks.
  List<Seat> get sleeperSeats =>
      allSeats.where((s) => s.type == SeatType.sleeper).toList();
}

/// Extension methods for [Seat] providing formatting and display helpers.
extension SeatX on Seat {
  /// Human-readable title for the seat's status.
  String get statusTitle {
    switch (status) {
      case SeatStatus.available:
        return 'Available';
      case SeatStatus.selected:
        return 'Selected';
      case SeatStatus.booked:
        return 'Booked';
      case SeatStatus.reserved:
        return 'Reserved';
      case SeatStatus.disabled:
        return 'Disabled';
      case SeatStatus.femaleOnly:
        return 'Female Only';
    }
  }

  /// Human-readable title for the seat's type.
  String get typeTitle {
    switch (type) {
      case SeatType.standard:
        return 'Standard';
      case SeatType.semiSleeper:
        return 'Semi-Sleeper';
      case SeatType.sleeper:
        return 'Sleeper';
      case SeatType.vip:
        return 'VIP';
    }
  }
}
