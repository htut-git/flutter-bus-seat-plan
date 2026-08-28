## [3.0.0] - ARCHITECTURAL OVERHAUL & PREMIUM UI

Version 3.0 is a complete reimagining of the package with a cleaner, highly maintainable architecture, simplified public API, high-performance vector rendering, reactive controller state management, and modern aesthetic themes.

### ✨ Highlights
- **Simplified Public API**: Common usage requires only `BusSeatPlan(seatLayout: layout, onSeatTap: (seat) {})`.
- **Clean V3 Architecture**:
  - `models/`: Immutable `Seat`, `SeatLayout`, `DeckLayout`, `LegendItem`, `SeatStatus`, `SeatType`.
  - `controllers/`: `SeatPlanController` for granular updates, max seat limits, and dynamic status overrides without rebuilding the entire tree.
  - `themes/`: `BusSeatThemeData` with built-in presets (`light`, `dark`, `luxury`, `emerald`) and customizable `SeatStyle`.
  - `painters/`: Vector rendering for ergonomic seats, sleeper bunks, steering wheels, and aerodynamic bus chassis frames.
  - `widgets/`: `BusSeatPlan`, `BusSeatWidget`, `BusLegendWidget`, `BusDriverWidget`, `BusChassisContainer`.
  - `utils/`: `LayoutParser` and `SeatExtensions`.
- **Different Seat Types**: First-class support for `standard`, `semiSleeper`, `sleeper`, and `vip` seats.
- **Seat Statuses**: `available`, `selected`, `booked`, `reserved`, `disabled`, and `femaleOnly`.
- **Double Decker & Multi-Deck Support**: Smooth animated deck switching between lower and upper decks.
- **Interactive Features**: Micro-animations on selection, pinch-to-zoom & pan (`enableInteractiveViewer`), and custom builders (`seatBuilder`, `driverBuilder`, `legendBuilder`).
- **Showcase Example App**: Standalone interactive playground located in `example/`.
- **Backward Compatibility**: Retained compatibility adapters for legacy v2 apps.

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
