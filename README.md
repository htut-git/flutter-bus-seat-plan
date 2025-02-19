## BusSeatPlanWidget

`BusSeatPlanWidget` is a customizable Flutter widget for displaying and interacting with a bus seat plan. It allows users to view, select, and manage seat bookings with various seat statuses.

### Features
- Customizable seat layout based on a provided seat map.
- Supports different seat statuses: available, booked, blocked, reserved, and in progress.
- Allows seat selection with a callback function.
- Displays custom icons for booked seats.
- Option to add a custom widget at the top.

### Installation
Ensure you have the necessary dependencies in your `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  bus_seat_plan:
```

### Usage
```dart
BusSeatPlanWidget(
  seatMap: [
    "ss_ss", 
    "ss_ss", 
    "ss_ss"
  ],
  prefix: 'A',
  bookedSeats: [
    BookedSeatModal(rawIds: ["1_1"], icon: Icon(Icons.check, color: Colors.white)),
  ],
  blockedSeats: ["1_2"],
  reserveSeats: ["2_1"],
  bookingSeats: ["2_2"],
  selectedSeats: [],
  seatSetusColor: SeatStatusColor(
    bookedColor: Colors.red,
    blockColor: Colors.grey,
    reserveColor: Colors.orange,
    bookingColor: Colors.blue,
    canBuyColor: Colors.green,
    selectedColor: Colors.yellow,
  ),
  clickSeat: (seat) {
    print("Seat clicked: \${seat.seatNo}");
  },
  callBackSelectedSeatCannotBuy: (seat) {
    print("Cannot buy seat: \${seat.seatNo}");
  },
  customTopWidget: (gridCount) => Text("Bus Seat Layout"),
)
```

### Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| `seatMap` | `List<String>` | Defines the seat layout using `s` for seats and spaces for aisles. |
| `prefix` | `String` | Prefix for seat numbering (e.g., 'A'). Default is 'A'. |
| `bookedSeats` | `List<BookedSeatModal>` | List of booked seats with custom icons. |
| `blockedSeats` | `List<String>` | List of blocked seats (cannot be selected). |
| `reserveSeats` | `List<String>` | List of reserved seats. |
| `bookingSeats` | `List<String>` | List of seats currently in booking. |
| `selectedSeats` | `List<SeatPlanModal>` | List of seats selected by the user. |
| `seatSetusColor` | `SeatStatusColor?` | Custom seat colors based on status. |
| `clickSeat` | `Function(SeatPlanModal)?` | Callback when a seat is clicked. |
| `callBackSelectedSeatCannotBuy` | `Function(SeatPlanModal)?` | Callback when a selected seat cannot be bought. |
| `customTopWidget` | `Widget Function(int gridCount)?` | Custom widget displayed above the seat layout. |

### Seat Status
| Status | Description |
|--------|-------------|
| `SeatStatus.canBuy` | The seat is available for selection. |
| `SeatStatus.booked` | The seat is booked and cannot be selected. |
| `SeatStatus.blocked` | The seat is blocked and cannot be selected. |
| `SeatStatus.reserved` | The seat is reserved. |
| `SeatStatus.booking` | The seat is in the process of being booked. |

### Example Seat Map
```dart
List<String> seatMap = [
  "ss__ss", // Row 1
  "ss__ss", // Row 2
  "ss__ss"  // Row 3
];
```
- `s` represents a seat.
- `_` represents an aisle space.

### License
This project is licensed under the MIT License.