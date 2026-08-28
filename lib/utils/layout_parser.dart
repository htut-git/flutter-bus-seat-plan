import '../models/seat.dart';

/// Utility class for parsing ASCII strings or grid matrices into structured [Seat] grids.
class LayoutParser {
  LayoutParser._();

  /// Default column letters: A, B, C, D, E, F, G, H...
  static String defaultSeatLabel(int row, int col, int deckIndex) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final letter = col < letters.length ? letters[col] : '${col + 1}';
    final prefix = deckIndex > 0 ? 'U' : '';
    return '$prefix${row + 1}$letter';
  }

  /// Parses a list of strings into a 2D matrix of `List<List<Seat?>>`.
  static List<List<Seat?>> parseStrings(
    List<String> stringMap, {
    int deckIndex = 0,
    String Function(int row, int col, int deck)? seatNoBuilder,
  }) {
    final matrix = <List<Seat?>>[];

    for (int r = 0; r < stringMap.length; r++) {
      final line = stringMap[r].trimRight();
      final rowSeats = <Seat?>[];
      int seatColIndex = 0;

      for (int c = 0; c < line.length; c++) {
        final char = line[c].toLowerCase();

        if (char == '_' || char == ' ' || char == '-') {
          rowSeats.add(null);
          continue;
        }

        final seatId = '${deckIndex}_${r + 1}_${c + 1}';
        final seatLabel = seatNoBuilder != null
            ? seatNoBuilder(r + 1, seatColIndex + 1, deckIndex)
            : defaultSeatLabel(r, seatColIndex, deckIndex);

        seatColIndex++;

        SeatStatus status = SeatStatus.available;
        SeatType type = SeatType.standard;

        switch (char) {
          case 's':
          case '1':
          case 'a':
            status = SeatStatus.available;
            type = SeatType.standard;
            break;
          case 'v':
            status = SeatStatus.available;
            type = SeatType.vip;
            break;
          case 'l':
            status = SeatStatus.available;
            type = SeatType.sleeper;
            break;
          case 'u':
            status = SeatStatus.available;
            type = SeatType.sleeper;
            break;
          case 'm':
            status = SeatStatus.available;
            type = SeatType.semiSleeper;
            break;
          case 'b':
          case 'x':
            status = SeatStatus.booked;
            type = SeatType.standard;
            break;
          case 'r':
            status = SeatStatus.reserved;
            type = SeatType.standard;
            break;
          case 'd':
            status = SeatStatus.disabled;
            type = SeatType.standard;
            break;
          case 'f':
            status = SeatStatus.femaleOnly;
            type = SeatType.standard;
            break;
          default:
            status = SeatStatus.available;
            type = SeatType.standard;
            break;
        }

        rowSeats.add(
          Seat(
            id: seatId,
            label: seatLabel,
            row: r,
            column: c,
            deckIndex: deckIndex,
            status: status,
            type: type,
          ),
        );
      }

      matrix.add(List.unmodifiable(rowSeats));
    }

    return List.unmodifiable(matrix);
  }
}
