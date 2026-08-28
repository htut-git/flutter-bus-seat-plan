import 'package:flutter/foundation.dart';
import '../models/seat.dart';

/// A reactive controller that manages seat selection, max selection limits,
/// dynamic seat status overrides, and real-time event notifications.
class SeatPlanController extends ChangeNotifier {
  /// Maximum number of seats a user can select at one time.
  /// If `null`, there is no selection limit.
  final int? maxSelectedSeats;

  /// Callback triggered when the user attempts to exceed [maxSelectedSeats].
  final VoidCallback? onMaxSeatsReached;

  /// Callback triggered whenever the selection changes.
  final ValueChanged<List<Seat>>? onSelectionChanged;

  final Map<String, Seat> _selectedSeatsMap = {};
  final Map<String, SeatStatus> _statusOverrides = {};

  /// Creates a [SeatPlanController].
  SeatPlanController({
    List<Seat> initialSelectedSeats = const [],
    this.maxSelectedSeats,
    this.onMaxSeatsReached,
    this.onSelectionChanged,
  }) {
    for (final seat in initialSelectedSeats) {
      _selectedSeatsMap[seat.id] = seat.copyWith(status: SeatStatus.selected);
    }
  }

  /// List of currently selected [Seat] items.
  List<Seat> get selectedSeats =>
      List.unmodifiable(_selectedSeatsMap.values.toList());

  /// Set of currently selected seat IDs.
  Set<String> get selectedSeatIds =>
      Set.unmodifiable(_selectedSeatsMap.keys.toSet());

  /// Total count of currently selected seats.
  int get selectedCount => _selectedSeatsMap.length;

  /// Total price calculated from all selected seats that have a price specified.
  double get totalPrice => _selectedSeatsMap.values
      .fold<double>(0.0, (sum, seat) => sum + (seat.price ?? 0.0));

  /// Checks whether the seat with [seatId] or [seat] is currently selected.
  bool isSelected(Seat seat) => _selectedSeatsMap.containsKey(seat.id);

  /// Checks whether a seat ID is currently selected.
  bool isSelectedId(String seatId) => _selectedSeatsMap.containsKey(seatId);

  /// Retrieves the effective status of a seat, taking into account current selection
  /// and any runtime overrides.
  SeatStatus getEffectiveStatus(Seat seat) {
    if (_selectedSeatsMap.containsKey(seat.id)) {
      return SeatStatus.selected;
    }
    return _statusOverrides[seat.id] ?? seat.status;
  }

  /// Toggles the selection state of a given [seat].
  ///
  /// Returns `true` if the state changed, or `false` if selection was blocked
  /// (e.g. non-selectable seat, or max selection limit reached).
  bool toggle(Seat seat) {
    if (isSelected(seat)) {
      return deselect(seat);
    } else {
      return select(seat);
    }
  }

  /// Selects the given [seat].
  ///
  /// Returns `true` if selected successfully, `false` otherwise.
  bool select(Seat seat) {
    final currentStatus = getEffectiveStatus(seat);
    if (currentStatus == SeatStatus.booked ||
        currentStatus == SeatStatus.reserved ||
        currentStatus == SeatStatus.disabled) {
      return false;
    }

    if (maxSelectedSeats != null &&
        _selectedSeatsMap.length >= maxSelectedSeats! &&
        !_selectedSeatsMap.containsKey(seat.id)) {
      onMaxSeatsReached?.call();
      return false;
    }

    _selectedSeatsMap[seat.id] = seat.copyWith(status: SeatStatus.selected);
    notifyListeners();
    onSelectionChanged?.call(selectedSeats);
    return true;
  }

  /// Deselects the given [seat].
  ///
  /// Returns `true` if deselected successfully.
  bool deselect(Seat seat) {
    if (_selectedSeatsMap.remove(seat.id) != null) {
      notifyListeners();
      onSelectionChanged?.call(selectedSeats);
      return true;
    }
    return false;
  }

  /// Clears all currently selected seats.
  void clearSelection() {
    if (_selectedSeatsMap.isNotEmpty) {
      _selectedSeatsMap.clear();
      notifyListeners();
      onSelectionChanged?.call(selectedSeats);
    }
  }

  /// Replaces the entire selection with [newSelection].
  void setSelection(List<Seat> newSelection) {
    _selectedSeatsMap.clear();
    for (final seat in newSelection) {
      if (maxSelectedSeats != null &&
          _selectedSeatsMap.length >= maxSelectedSeats!) {
        break;
      }
      _selectedSeatsMap[seat.id] = seat.copyWith(status: SeatStatus.selected);
    }
    notifyListeners();
    onSelectionChanged?.call(selectedSeats);
  }

  /// Dynamically updates the runtime status of a specific seat (e.g., from a WebSocket event).
  void overrideSeatStatus(String seatId, SeatStatus newStatus) {
    if (newStatus == SeatStatus.booked ||
        newStatus == SeatStatus.reserved ||
        newStatus == SeatStatus.disabled) {
      _selectedSeatsMap.remove(seatId);
    }
    _statusOverrides[seatId] = newStatus;
    notifyListeners();
  }

  /// Clears all dynamic seat status overrides.
  void clearStatusOverrides() {
    if (_statusOverrides.isNotEmpty) {
      _statusOverrides.clear();
      notifyListeners();
    }
  }
}
