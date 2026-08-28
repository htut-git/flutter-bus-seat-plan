import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../utils/layout_parser.dart';
import 'seat.dart';

/// Represents a single deck/floor within a bus layout.
@immutable
class DeckLayout extends Equatable {
  /// Name or label for this deck (e.g. "Lower Deck", "Upper Deck", "Main Cabin").
  final String name;

  /// Index of the deck (0 for lower/main deck, 1 for upper deck).
  final int deckIndex;

  /// 2D grid matrix of seats for this deck. Elements can be null for aisles/empty spots.
  final List<List<Seat?>> matrix;

  /// Driver cabin location for this deck.
  final DriverPosition driverPosition;

  /// Row index where an entrance/exit door is situated, if any.
  final int? doorRowIndex;

  /// Creates a [DeckLayout].
  const DeckLayout({
    required this.name,
    required this.matrix,
    this.deckIndex = 0,
    this.driverPosition = DriverPosition.left,
    this.doorRowIndex,
  });

  /// Total number of rows in this deck.
  int get rowCount => matrix.length;

  /// Total number of columns in this deck.
  int get columnCount => matrix.isEmpty ? 0 : matrix.first.length;

  /// Flattened list of all valid (non-null) seats in this deck.
  List<Seat> get seats =>
      matrix.expand((row) => row.whereType<Seat>()).toList(growable: false);

  /// Total number of valid seats.
  int get seatCount => seats.length;

  /// Retrieves the seat at the specified [row] and [column], or null if empty/aisle.
  Seat? seatAt(int row, int column) {
    if (row >= 0 && row < matrix.length) {
      final rowList = matrix[row];
      if (column >= 0 && column < rowList.length) {
        return rowList[column];
      }
    }
    return null;
  }

  /// Copies this [DeckLayout] with updated values.
  DeckLayout copyWith({
    String? name,
    int? deckIndex,
    List<List<Seat?>>? matrix,
    DriverPosition? driverPosition,
    int? doorRowIndex,
  }) {
    return DeckLayout(
      name: name ?? this.name,
      deckIndex: deckIndex ?? this.deckIndex,
      matrix: matrix ?? this.matrix,
      driverPosition: driverPosition ?? this.driverPosition,
      doorRowIndex: doorRowIndex ?? this.doorRowIndex,
    );
  }

  @override
  List<Object?> get props => [
        name,
        deckIndex,
        matrix,
        driverPosition,
        doorRowIndex,
      ];
}

/// The top-level specification of a bus seat layout.
/// Can represent single-deck or multi-deck (e.g., sleeper/double decker) buses.
@immutable
class SeatLayout extends Equatable {
  /// List of decks in this layout.
  final List<DeckLayout> decks;

  /// Creates a [SeatLayout] with explicit [decks].
  const SeatLayout({
    required this.decks,
  }) : assert(decks.length > 0, 'A SeatLayout must have at least one deck.');

  /// Convenience constructor for a single-deck bus.
  factory SeatLayout.singleDeck({
    String name = 'Main Deck',
    required List<List<Seat?>> matrix,
    DriverPosition driverPosition = DriverPosition.left,
    int? doorRowIndex,
  }) {
    return SeatLayout(
      decks: [
        DeckLayout(
          name: name,
          deckIndex: 0,
          matrix: matrix,
          driverPosition: driverPosition,
          doorRowIndex: doorRowIndex,
        ),
      ],
    );
  }

  /// Convenience constructor for a double-deck bus.
  factory SeatLayout.doubleDeck({
    required DeckLayout lowerDeck,
    required DeckLayout upperDeck,
  }) {
    return SeatLayout(
      decks: [
        lowerDeck.copyWith(deckIndex: 0),
        upperDeck.copyWith(deckIndex: 1, driverPosition: DriverPosition.none),
      ],
    );
  }

  /// High-level factory to parse a standard ASCII string pattern into a [SeatLayout].
  ///
  /// Symbols recognized by default:
  /// - `s` or `1`: Standard available seat
  /// - `v`: VIP seat
  /// - `l`: Sleeper berth (Lower)
  /// - `u`: Sleeper berth (Upper)
  /// - `b` or `x`: Booked seat
  /// - `r`: Reserved seat
  /// - `d`: Disabled / blocked seat
  /// - `f`: Female-only seat
  /// - `_` or ` ` (space): Aisle / empty space
  factory SeatLayout.fromStrings(
    List<String> stringMap, {
    String deckName = 'Main Deck',
    DriverPosition driverPosition = DriverPosition.left,
    String Function(int row, int col, int deck)? seatNoBuilder,
    int? doorRowIndex,
  }) {
    final matrix = LayoutParser.parseStrings(
      stringMap,
      deckIndex: 0,
      seatNoBuilder: seatNoBuilder,
    );
    return SeatLayout.singleDeck(
      name: deckName,
      matrix: matrix,
      driverPosition: driverPosition,
      doorRowIndex: doorRowIndex,
    );
  }

  /// High-level factory for multi-deck buses using ASCII string patterns.
  factory SeatLayout.multiDeckFromStrings({
    required List<String> lowerDeckMap,
    required List<String> upperDeckMap,
    String lowerDeckName = 'Lower Deck',
    String upperDeckName = 'Upper Deck',
    DriverPosition driverPosition = DriverPosition.left,
    String Function(int row, int col, int deck)? seatNoBuilder,
    int? doorRowIndex,
  }) {
    final lowerMatrix = LayoutParser.parseStrings(
      lowerDeckMap,
      deckIndex: 0,
      seatNoBuilder: seatNoBuilder,
    );
    final upperMatrix = LayoutParser.parseStrings(
      upperDeckMap,
      deckIndex: 1,
      seatNoBuilder: seatNoBuilder,
    );
    return SeatLayout.doubleDeck(
      lowerDeck: DeckLayout(
        name: lowerDeckName,
        deckIndex: 0,
        matrix: lowerMatrix,
        driverPosition: driverPosition,
        doorRowIndex: doorRowIndex,
      ),
      upperDeck: DeckLayout(
        name: upperDeckName,
        deckIndex: 1,
        matrix: upperMatrix,
        driverPosition: DriverPosition.none,
      ),
    );
  }

  /// Creates a layout directly from an arbitrary list of [Seat] instances.
  factory SeatLayout.fromSeats({
    required List<Seat> seats,
    int rows = 0,
    int columns = 0,
    String deckName = 'Main Deck',
    DriverPosition driverPosition = DriverPosition.left,
    int? doorRowIndex,
  }) {
    int maxR = rows > 0 ? rows : 0;
    int maxC = columns > 0 ? columns : 0;

    for (final s in seats) {
      if (s.row + 1 > maxR) maxR = s.row + 1;
      if (s.column + 1 > maxC) maxC = s.column + 1;
    }

    final matrix = List.generate(
      maxR,
      (r) => List<Seat?>.filled(maxC, null, growable: false),
      growable: false,
    );

    for (final s in seats) {
      if (s.row < maxR && s.column < maxC) {
        matrix[s.row][s.column] = s;
      }
    }

    return SeatLayout.singleDeck(
      name: deckName,
      matrix: matrix,
      driverPosition: driverPosition,
      doorRowIndex: doorRowIndex,
    );
  }

  /// Whether this layout contains more than one deck.
  bool get isMultiDeck => decks.length > 1;

  /// Returns the primary/first deck.
  DeckLayout get primaryDeck => decks.first;

  /// Flattened list of all seats across all decks.
  List<Seat> get allSeats =>
      decks.expand((d) => d.seats).toList(growable: false);

  /// Total count of all valid seats across all decks.
  int get totalSeatCount => allSeats.length;

  /// Finds a seat by its [id] across all decks, or null if not found.
  Seat? findSeatById(String id) {
    for (final deck in decks) {
      for (final row in deck.matrix) {
        for (final seat in row) {
          if (seat != null && seat.id == id) {
            return seat;
          }
        }
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [decks];
}
