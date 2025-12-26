# Bus Seat Plan

A Flutter package for managing bus seat layouts and seat selection.

## Features

- **Customizable Seat Layout**: Define your bus layout with a simple `List<String>`.
- **Seat Statuses**: Supports various seat statuses like available, booked, reserved, and disabled.
- **Callbacks**: Get notified when a seat is selected.
- **Customization**: Customize seat colors and add custom widgets.

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  bus_seat_plan: ^1.0.0
```

Then, run `flutter pub get`.

## Usage

Here's a simple example of how to use the `BusSeatPlanWidget`:

```dart
import 'package:flutter/material.dart';
import 'package:bus_seat_plan/bus_seat_plan.dart';

class SeatPlanScreen extends StatefulWidget {
  const SeatPlanScreen({super.key});

  @override
  State<SeatPlanScreen> createState() => _SeatPlanScreenState();
}

class _SeatPlanScreenState extends State<SeatPlanScreen> {
  final List<Seat> _selectedSeats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Seat Plan'),
      ),
      body: BusSeatPlanWidget(
        seatMap: const [
          'ss_ss',
          'ss_ss',
          'ss__ss',
        ],
        onSeatSelect: (seat) {
          setState(() {
            if (_selectedSeats.contains(seat)) {
              _selectedSeats.remove(seat);
            } else {
              _selectedSeats.add(seat);
            }
          });
        },
        seatNoBuilder: (row, col) {
          return 'S$row-$col';
        },
        selectedSeats: _selectedSeats,
        bookedSeats: [
          BookedSeat(
            rawIds: ['1_1'],
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        ],
        reservedSeats: const ['1_2'],
        disabledSeats: const ['1_4'],
      ),
    );
  }
}
```

## Parameters

| Parameter       | Type                       | Description                                                  |
| --------------- | -------------------------- | ------------------------------------------------------------ |
| `seatMap`       | `List<String>`             | **Required.** The layout of the seats. `s` for a seat, `_` for an empty space. |
| `onSeatSelect`  | `ValueChanged<Seat>`       | **Required.** Callback function when a seat is tapped.         |
| `seatNoBuilder` | `String Function(int, int)` | **Required.** A function to build the seat number from its row and column. |
| `selectedSeats` | `List<Seat>`               | A list of currently selected seats.                          |
| `bookedSeats`   | `List<BookedSeat>`         | A list of seats that are already booked.                     |
| `reservedSeats` | `List<String>`             | A list of seats that are reserved.                           |
| `disabledSeats` | `List<String>`             | A list of seats that are disabled.                           |
| `seatStatusColor`| `SeatStatusColor`         | The colors for different seat statuses.                      |
| `customTopWidget`| `Widget Function(int)`     | A widget to display at the top of the seat plan.             |
| `maxScreenWidth`| `double`                   | The maximum width of the seat plan.                          |

## Seat Status

| Status      | Description                               |
| ----------- | ----------------------------------------- |
| `available` | The seat is available for selection.      |
| `booked`    | The seat is already booked.               |
| `reserved`  | The seat is reserved.                     |
| `disabled`  | The seat is disabled and cannot be selected. |
| `selected`  | The seat is currently selected.           |

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
