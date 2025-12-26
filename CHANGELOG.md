## [2.0.0] - MAJOR REFACTOR
This release is a complete overhaul of the package, introducing a more robust, intuitive, and maintainable API.

### BREAKING CHANGES
- The entire `BusSeatPlanWidget` has been refactored and is now a `StatefulWidget` for better performance.
- The data models have been redesigned. `SeatPlanModal` and `BookedSeatModal` are replaced by the immutable `Seat` and `BookedSeat` classes.
- The `clickSeat` callback has been renamed to `onSeatSelect` and now uses the `ValueChanged<Seat>` signature.
- The `blockedSeats` parameter is now `disabledSeats`.
- The `prefix` parameter has been removed. The `seatNoBuilder` is now the sole method for generating seat numbers.
- The `callBackSelectedSeatCannotBuy` parameter has been removed. Disabled or booked seats are no longer tappable.
- The `bookingSeats` parameter has been removed to simplify the API.

### Added
- A comprehensive suite of widget tests to ensure the reliability of the widget.
- A cleaner, more declarative API that is easier to use.
- Immutable data models with a `copyWith` method for predictable state management.

## [1.0.0] - 2025-05-11
### Added
- Made seat number customizable using the new `seatNoBuilder` parameter in `BusSeatPlanWidget`.
  - Developers can now define custom seat labels dynamically based on row, column, and prefix.

### Fixed
- Corrected a typo in the `seatStatusColor` property.

## [0.0.3] - 2025-02-21
### Added
- Added `maxScreenWidth` to fix UI issues in the Flutter package.

## [0.0.1] - Initial Release
### Added
- Implemented **Bus Seat Plan Widget** for Flutter.
- Supports customizable seat layouts.
- Allows seat selection with dynamic pricing.
- Responsive design for different screen sizes.
