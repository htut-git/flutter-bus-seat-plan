import 'package:bus_seat_plan/bus_seat_plan.dart';

/// Pre-configured bus layout fixtures for the showcase application.
class DemoLayouts {
  DemoLayouts._();

  /// 1. Standard 2+2 Intercity Express Coach (40 Seats)
  static SeatLayout standardExpress() {
    return SeatLayout.fromStrings(
      [
        'ss_ss',
        'ss_ss',
        'bx_ss',
        'ss_rd',
        'ff_ss',
        'ss_ss',
        'bx_bx',
        'ss_ss',
        'ss_ss',
        'sssss',
      ],
      deckName: 'Main Cabin',
      driverPosition: DriverPosition.left,
    );
  }

  /// 2. VIP Executive 2+1 First Class Recliner Coach
  static SeatLayout vipExecutive() {
    final matrix = LayoutParser.parseStrings([
      'vv_v',
      'vv_v',
      'bv_v',
      'vv_r',
      'ff_v',
      'vv_v',
      'vv_v',
      'vvvv',
    ]);

    // Attach premium pricing ($45.00) and custom metadata
    final enhancedMatrix = matrix.map((row) {
      return row.map((seat) {
        if (seat == null) return null;
        return seat.copyWith(
          price: 45.0,
          type: SeatType.vip,
        );
      }).toList();
    }).toList();

    return SeatLayout.singleDeck(
      name: 'VIP Executive Club',
      matrix: enhancedMatrix,
      driverPosition: DriverPosition.left,
    );
  }

  /// 3. Royal Sleeper 1+1+1 Night Coach (Lower & Upper Bunks)
  static SeatLayout royalSleeper() {
    return SeatLayout.multiDeckFromStrings(
      lowerDeckMap: [
        'l_l_l',
        'l_l_l',
        'b_l_r',
        'l_l_l',
        'l_l_l',
      ],
      upperDeckMap: [
        'u_u_u',
        'u_u_u',
        'b_u_u',
        'u_u_d',
        'u_u_u',
      ],
      lowerDeckName: 'Lower Berth (Single/Double)',
      upperDeckName: 'Upper Berth (Panoramic)',
      driverPosition: DriverPosition.right,
    );
  }

  /// 4. Double Decker Grand Cruiser (Lower Standard + Upper Luxury Sleeper)
  static SeatLayout doubleDeckerCruiser() {
    final lowerMatrix = LayoutParser.parseStrings([
      'ss_ss',
      'ss_ss',
      'bx_ss',
      'vv_vv',
      'vv_vv',
      'sssss',
    ]);

    final upperMatrix = LayoutParser.parseStrings([
      'l_l_l',
      'l_l_l',
      'b_l_l',
      'l_l_l',
      'l_l_l',
    ]);

    return SeatLayout.doubleDeck(
      lowerDeck: DeckLayout(
        name: 'Lower Deck (Standard & VIP)',
        deckIndex: 0,
        matrix: lowerMatrix,
        driverPosition: DriverPosition.left,
      ),
      upperDeck: DeckLayout(
        name: 'Upper Deck (Lie-Flat Sleeper)',
        deckIndex: 1,
        matrix: upperMatrix,
        driverPosition: DriverPosition.none,
      ),
    );
  }
}
