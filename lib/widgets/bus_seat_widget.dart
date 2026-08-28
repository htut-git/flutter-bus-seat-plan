import 'package:flutter/material.dart';
import '../models/seat.dart';
import '../painters/seat_painter.dart';
import '../painters/sleeper_seat_painter.dart';
import '../themes/bus_seat_theme.dart';
import '../themes/seat_style.dart';

/// Individual seat widget rendering clean vector graphics, selection animations,
/// hover feedback, and custom builder support.
class BusSeatWidget extends StatefulWidget {
  final Seat seat;
  final SeatStatus effectiveStatus;
  final BusSeatThemeData theme;
  final ValueChanged<Seat>? onTap;
  final ValueChanged<Seat>? onLongPress;
  final Widget Function(BuildContext context, Seat seat, SeatStatus status, BusSeatThemeData theme)? customBuilder;

  const BusSeatWidget({
    super.key,
    required this.seat,
    required this.effectiveStatus,
    required this.theme,
    this.onTap,
    this.onLongPress,
    this.customBuilder,
  });

  @override
  State<BusSeatWidget> createState() => _BusSeatWidgetState();
}

class _BusSeatWidgetState extends State<BusSeatWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.seat.isSelectable) {
      _animController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.seat.isSelectable) {
      _animController.reverse();
      widget.onTap?.call(widget.seat);
    }
  }

  void _handleTapCancel() {
    if (widget.seat.isSelectable) {
      _animController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.theme.styleForSeat(widget.seat, widget.effectiveStatus);

    if (widget.customBuilder != null) {
      return widget.customBuilder!(context, widget.seat, widget.effectiveStatus, widget.theme);
    }

    final isSleeper = widget.seat.type == SeatType.sleeper;
    final width = isSleeper ? widget.theme.sleeperWidth : widget.theme.seatWidth;
    final height = isSleeper ? widget.theme.sleeperHeight : widget.theme.seatHeight;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.theme.seatGap / 2,
        vertical: widget.theme.rowGap / 2,
      ),
      child: MouseRegion(
        cursor: widget.seat.isSelectable
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onLongPress: widget.onLongPress != null && widget.seat.isSelectable
              ? () => widget.onLongPress!(widget.seat)
              : null,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: SizedBox(
                  width: width,
                  height: height,
                  child: RepaintBoundary(
                    child: widget.theme.useVectorSeats
                        ? _buildVectorSeat(style, width, height)
                        : _buildFlatSeat(style, width, height),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVectorSeat(SeatStyle style, double width, double height) {
    final isSleeper = widget.seat.type == SeatType.sleeper;

    return CustomPaint(
      size: Size(width, height),
      painter: isSleeper
          ? SleeperSeatPainter(
              seat: widget.seat,
              effectiveStatus: widget.effectiveStatus,
              style: style,
              isHovered: _isHovered,
            )
          : SeatPainter(
              seat: widget.seat,
              effectiveStatus: widget.effectiveStatus,
              style: style,
              isHovered: _isHovered,
            ),
      child: Center(
        child: _buildSeatContent(style),
      ),
    );
  }

  Widget _buildFlatSeat(SeatStyle style, double width, double height) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        gradient: style.backgroundGradient,
        borderRadius: style.borderRadius,
        border: Border.all(
          color: style.borderColor,
          width: style.borderWidth,
        ),
        boxShadow: style.shadows,
      ),
      child: Center(
        child: _buildSeatContent(style),
      ),
    );
  }

  Widget _buildSeatContent(SeatStyle style) {
    if (widget.seat.icon != null) {
      return Center(child: widget.seat.icon!);
    }

    if (!widget.theme.showSeatNumbers) {
      return const SizedBox.shrink();
    }

    final defaultTextStyle = TextStyle(
      color: style.foregroundColor,
      fontSize: widget.seat.label.length > 3 ? 10.5 : 12.5,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
    );

    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          top: widget.seat.type == SeatType.sleeper ? 10.0 : 2.0,
        ),
        child: Text(
          widget.seat.label,
          style: style.textStyle ?? defaultTextStyle,
          maxLines: 1,
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
