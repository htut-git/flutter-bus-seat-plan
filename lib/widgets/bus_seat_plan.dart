import 'package:flutter/material.dart';
import '../controllers/seat_plan_controller.dart';
import '../models/legend_item.dart';
import '../models/seat.dart';
import '../models/seat_layout.dart';
import '../themes/bus_seat_theme.dart';
import 'bus_chassis_container.dart';
import 'bus_driver_widget.dart';
import 'bus_legend_widget.dart';
import 'bus_seat_widget.dart';

/// The primary modern widget for rendering an interactive, beautifully styled
/// bus seat layout in Flutter.
///
/// Basic usage:
/// ```dart
/// BusSeatPlan(
///   seatLayout: layout,
///   onSeatTap: (seat) {
///     print('Tapped seat ${seat.label}');
///   },
/// )
/// ```
class BusSeatPlan extends StatefulWidget {
  /// The specification of the bus seats, rows, columns, and decks.
  final SeatLayout seatLayout;

  /// Optional external controller to programmatically manage selections,
  /// max limits, dynamic status updates, and events.
  final SeatPlanController? controller;

  /// Visual theme configuration. Defaults to [BusSeatThemeData.light()].
  final BusSeatThemeData? theme;

  /// Callback fired when a selectable seat is tapped.
  final ValueChanged<Seat>? onSeatTap;

  /// Callback fired when a seat is long-pressed.
  final ValueChanged<Seat>? onSeatLongPress;

  /// Callback fired when the selection changes.
  final ValueChanged<List<Seat>>? onSelectionChanged;

  /// Callback fired when the user attempts to select more than [maxSelectedSeats].
  final VoidCallback? onMaxSeatsReached;

  /// Maximum seats selectable at once (used if [controller] is not provided).
  final int? maxSelectedSeats;

  /// Initially selected seats (used if [controller] is not provided).
  final List<Seat>? initialSelectedSeats;

  /// Custom builder for seat widgets.
  final Widget Function(
    BuildContext context,
    Seat seat,
    SeatStatus status,
    BusSeatThemeData theme,
  )? seatBuilder;

  /// Custom builder for the driver cabin area.
  final Widget Function(
    BuildContext context,
    DriverPosition position,
    BusSeatThemeData theme,
  )? driverBuilder;

  /// Custom builder for the legend.
  final Widget Function(
    BuildContext context,
    List<LegendItem> items,
    BusSeatThemeData theme,
  )? legendBuilder;

  /// Custom builder for empty / aisle spots in the grid.
  final Widget Function(BuildContext context, int row, int col)?
      emptySeatBuilder;

  /// Custom widget builder placed above the bus layout (e.g. route info / header).
  final Widget Function(BuildContext context)? headerBuilder;

  /// Custom widget builder placed below the bus layout.
  final Widget Function(BuildContext context)? footerBuilder;

  /// Custom deck switcher widget builder for multi-deck buses.
  final Widget Function(
    BuildContext context,
    int activeDeckIndex,
    List<DeckLayout> decks,
    ValueChanged<int> onDeckChanged,
  )? deckSwitcherBuilder;

  /// Custom legend items list. If omitted, generated automatically from layout.
  final List<LegendItem>? legendItems;

  /// Whether to show the driver cabin. If null, inherits from [BusSeatThemeData.showDriverArea].
  final bool? showDriver;

  /// Whether to show the legend. If null, inherits from [BusSeatThemeData.showLegend].
  final bool? showLegend;

  /// Whether to show the outer bus frame/chassis. If null, inherits from [BusSeatThemeData.showBusFrame].
  final bool? showBusFrame;

  /// Whether to show row numbers along the side of the bus.
  final bool showRowNumbers;

  /// Custom builder for row number text labels.
  final String Function(int rowIndex)? rowNumberBuilder;

  /// Whether to enable pinch-to-zoom and pan via [InteractiveViewer].
  final bool enableInteractiveViewer;

  /// Minimum zoom scale if [enableInteractiveViewer] is true.
  final double minScale;

  /// Maximum zoom scale if [enableInteractiveViewer] is true.
  final double maxScale;

  /// Scroll physics for the seat plan scroll view.
  final ScrollPhysics? scrollPhysics;

  const BusSeatPlan({
    super.key,
    required this.seatLayout,
    this.controller,
    this.theme,
    this.onSeatTap,
    this.onSeatLongPress,
    this.onSelectionChanged,
    this.onMaxSeatsReached,
    this.maxSelectedSeats,
    this.initialSelectedSeats,
    this.seatBuilder,
    this.driverBuilder,
    this.legendBuilder,
    this.emptySeatBuilder,
    this.headerBuilder,
    this.footerBuilder,
    this.deckSwitcherBuilder,
    this.legendItems,
    this.showDriver,
    this.showLegend,
    this.showBusFrame,
    this.showRowNumbers = false,
    this.rowNumberBuilder,
    this.enableInteractiveViewer = false,
    this.minScale = 0.8,
    this.maxScale = 2.5,
    this.scrollPhysics,
  });

  @override
  State<BusSeatPlan> createState() => _BusSeatPlanState();
}

class _BusSeatPlanState extends State<BusSeatPlan> {
  SeatPlanController? _internalController;
  int _activeDeckIndex = 0;

  SeatPlanController get _effectiveController =>
      widget.controller ?? _internalController!;

  BusSeatThemeData get _effectiveTheme =>
      widget.theme ?? BusSeatThemeData.light();

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalController = SeatPlanController(
        initialSelectedSeats: widget.initialSelectedSeats ?? const [],
        maxSelectedSeats: widget.maxSelectedSeats,
        onMaxSeatsReached: widget.onMaxSeatsReached,
        onSelectionChanged: widget.onSelectionChanged,
      );
    }
  }

  @override
  void didUpdateWidget(covariant BusSeatPlan oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null) {
      _internalController = SeatPlanController(
        initialSelectedSeats: widget.initialSelectedSeats ?? const [],
        maxSelectedSeats: widget.maxSelectedSeats,
        onMaxSeatsReached: widget.onMaxSeatsReached,
        onSelectionChanged: widget.onSelectionChanged,
      );
    } else if (widget.controller != null && oldWidget.controller == null) {
      _internalController?.dispose();
      _internalController = null;
    }
  }

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  void _handleSeatTap(Seat seat) {
    if (!seat.isSelectable) return;

    _effectiveController.toggle(seat);
    widget.onSeatTap?.call(seat);
  }

  @override
  Widget build(BuildContext context) {
    final theme = _effectiveTheme;
    final decks = widget.seatLayout.decks;
    final currentDeck = decks[_activeDeckIndex.clamp(0, decks.length - 1)];

    Widget content = AnimatedBuilder(
      animation: _effectiveController,
      builder: (context, _) {
        return SingleChildScrollView(
          physics: widget.scrollPhysics ?? const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Optional Header
                if (widget.headerBuilder != null) ...[
                  widget.headerBuilder!(context),
                  const SizedBox(height: 16),
                ],

                // Deck Switcher for Multi-Deck Buses
                if (decks.length > 1) ...[
                  _buildDeckSwitcher(decks, theme),
                  const SizedBox(height: 16),
                ],

                // Bus Chassis Container (Tightly fits the seating grid)
                BusChassisContainer(
                  theme: theme.copyWith(
                    showBusFrame: widget.showBusFrame ?? theme.showBusFrame,
                  ),
                  hasDriver: (widget.showDriver ?? theme.showDriverArea) &&
                      currentDeck.driverPosition != DriverPosition.none,
                  doorRowIndex: currentDeck.doorRowIndex,
                  child: IntrinsicWidth(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Driver Cabin Row (snugly aligns with seat columns)
                        _buildDriverRow(currentDeck, theme),

                        // Seat Grid
                        _buildDeckGrid(currentDeck, theme),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Legend
                if (widget.showLegend ?? theme.showLegend) ...[
                  BusLegendWidget(
                    items: widget.legendItems ?? _generateDefaultLegendItems(),
                    theme: theme,
                    customBuilder: widget.legendBuilder,
                  ),
                  const SizedBox(height: 16),
                ],

                // Optional Footer
                if (widget.footerBuilder != null)
                  widget.footerBuilder!(context),
              ],
            ),
          ),
        );
      },
    );

    if (widget.enableInteractiveViewer) {
      return InteractiveViewer(
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        child: content,
      );
    }

    return content;
  }

  Widget _buildDriverRow(DeckLayout deck, BusSeatThemeData theme) {
    if (!(widget.showDriver ?? theme.showDriverArea) ||
        deck.driverPosition == DriverPosition.none) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (widget.showRowNumbers) const SizedBox(width: 28),
          if (deck.driverPosition == DriverPosition.left) ...[
            BusDriverWidget(
              position: DriverPosition.left,
              theme: theme,
              customBuilder: widget.driverBuilder,
            ),
            const Spacer(),
          ] else if (deck.driverPosition == DriverPosition.right) ...[
            const Spacer(),
            BusDriverWidget(
              position: DriverPosition.right,
              theme: theme,
              customBuilder: widget.driverBuilder,
            ),
          ] else ...[
            const Spacer(),
            BusDriverWidget(
              position: DriverPosition.center,
              theme: theme,
              customBuilder: widget.driverBuilder,
            ),
            const Spacer(),
          ],
          if (widget.showRowNumbers) const SizedBox(width: 28),
        ],
      ),
    );
  }

  Widget _buildDeckSwitcher(List<DeckLayout> decks, BusSeatThemeData theme) {
    if (widget.deckSwitcherBuilder != null) {
      return widget.deckSwitcherBuilder!(
        context,
        _activeDeckIndex,
        decks,
        (index) => setState(() => _activeDeckIndex = index),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.busBodyColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.busBorderColor, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(decks.length, (index) {
          final isSelected = index == _activeDeckIndex;
          return GestureDetector(
            onTap: () => setState(() => _activeDeckIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.selectedStyle.backgroundColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                decks[index].name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? theme.selectedStyle.foregroundColor
                      : theme.availableStyle.foregroundColor.withValues(alpha: 0.7),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDeckGrid(DeckLayout deck, BusSeatThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(deck.rowCount, (rowIndex) {
        final rowSeats = deck.matrix[rowIndex];

        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Optional Row Number label on left
            if (widget.showRowNumbers) ...[
              SizedBox(
                width: 24,
                child: Text(
                  widget.rowNumberBuilder != null
                      ? widget.rowNumberBuilder!(rowIndex + 1)
                      : '${rowIndex + 1}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.availableStyle.foregroundColor.withValues(alpha: 0.5),
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],

            // Row Seats
            ...List.generate(rowSeats.length, (colIndex) {
              final seat = rowSeats[colIndex];
              if (seat != null) {
                final effectiveStatus =
                    _effectiveController.getEffectiveStatus(seat);

                return BusSeatWidget(
                  seat: seat,
                  effectiveStatus: effectiveStatus,
                  theme: theme,
                  onTap: _handleSeatTap,
                  onLongPress: widget.onSeatLongPress,
                  customBuilder: widget.seatBuilder,
                );
              } else {
                if (widget.emptySeatBuilder != null) {
                  return widget.emptySeatBuilder!(context, rowIndex, colIndex);
                }
                return SizedBox(
                  width: theme.aisleGap,
                  height: theme.seatHeight,
                );
              }
            }),

            if (widget.showRowNumbers) const SizedBox(width: 28),
          ],
        );
      }),
    );
  }

  List<LegendItem> _generateDefaultLegendItems() {
    final allSeats = widget.seatLayout.allSeats;
    final hasVip = allSeats.any((s) => s.type == SeatType.vip);
    final hasSleeper = allSeats.any((s) => s.type == SeatType.sleeper);
    final hasFemale = allSeats.any((s) => s.status == SeatStatus.femaleOnly);
    final hasReserved = allSeats.any((s) => s.status == SeatStatus.reserved);
    final hasBooked = allSeats.any((s) => s.status == SeatStatus.booked);
    final hasDisabled = allSeats.any((s) => s.status == SeatStatus.disabled);

    final items = <LegendItem>[
      LegendItem.available(),
      LegendItem.selected(),
    ];

    if (hasBooked) items.add(LegendItem.booked());
    if (hasReserved) items.add(LegendItem.reserved());
    if (hasFemale) items.add(LegendItem.femaleOnly());
    if (hasDisabled) items.add(LegendItem.disabled());
    if (hasVip) items.add(LegendItem.vip());
    if (hasSleeper) items.add(LegendItem.sleeper());

    return items;
  }
}
