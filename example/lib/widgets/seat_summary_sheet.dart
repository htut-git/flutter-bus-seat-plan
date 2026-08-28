import 'package:bus_seat_plan/bus_seat_plan.dart';
import 'package:flutter/material.dart';

/// Bottom bar / summary panel displaying selected seats, pricing, and actions.
class SeatSummarySheet extends StatelessWidget {
  final SeatPlanController controller;
  final BusSeatThemeData theme;
  final VoidCallback? onBookNow;

  const SeatSummarySheet({
    super.key,
    required this.controller,
    required this.theme,
    this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final selected = controller.selectedSeats;
        final count = selected.length;
        final hasSelection = count > 0;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: theme.busBodyColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, -4),
              ),
            ],
            border: Border(
              top: BorderSide(color: theme.busBorderColor, width: 1.2),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top row: Selected seats list chips
                Row(
                  children: [
                    Text(
                      'Selected ($count${controller.maxSelectedSeats != null ? '/${controller.maxSelectedSeats}' : ''}):',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: theme.availableStyle.foregroundColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: hasSelection
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: selected.map((seat) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 6.0),
                                    child: Chip(
                                      visualDensity: VisualDensity.compact,
                                      backgroundColor:
                                          theme.selectedStyle.backgroundColor.withValues(alpha: 0.15),
                                      side: BorderSide(
                                        color: theme.selectedStyle.backgroundColor,
                                        width: 1.0,
                                      ),
                                      label: Text(
                                        seat.label,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: theme.selectedStyle.backgroundColor,
                                        ),
                                      ),
                                      onDeleted: () => controller.deselect(seat),
                                      deleteIconColor: theme.selectedStyle.backgroundColor,
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          : Text(
                              'Tap any seat to select',
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.availableStyle.foregroundColor.withValues(alpha: 0.5),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                    ),
                    if (hasSelection)
                      TextButton(
                        onPressed: controller.clearSelection,
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                        child: const Text('Clear'),
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // Bottom row: Price & Confirm Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Estimated Total',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.availableStyle.foregroundColor.withValues(alpha: 0.6),
                          ),
                        ),
                        Text(
                          controller.totalPrice > 0
                              ? '\$${controller.totalPrice.toStringAsFixed(2)}'
                              : '\$${(count * 25.0).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: theme.availableStyle.foregroundColor,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: hasSelection ? onBookNow : null,
                      icon: const Icon(Icons.confirmation_number_outlined, size: 18),
                      label: const Text(
                        'Confirm Seats',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.selectedStyle.backgroundColor,
                        foregroundColor: theme.selectedStyle.foregroundColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
