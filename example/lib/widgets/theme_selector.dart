import 'package:flutter/material.dart';

enum DemoThemeType {
  light,
  dark,
  luxury,
  emerald,
}

/// Selector widget for switching themes and interactive visual preferences.
class ThemeSelector extends StatelessWidget {
  final DemoThemeType currentTheme;
  final ValueChanged<DemoThemeType> onThemeChanged;
  final bool showBusFrame;
  final ValueChanged<bool> onBusFrameChanged;
  final bool useVectorSeats;
  final ValueChanged<bool> onVectorSeatsChanged;
  final bool enableZoom;
  final ValueChanged<bool> onZoomChanged;

  const ThemeSelector({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
    required this.showBusFrame,
    required this.onBusFrameChanged,
    required this.useVectorSeats,
    required this.onVectorSeatsChanged,
    required this.enableZoom,
    required this.onZoomChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Theme presets
            _buildThemeChip(
              context,
              label: 'Light',
              icon: Icons.light_mode_outlined,
              isSelected: currentTheme == DemoThemeType.light,
              onTap: () => onThemeChanged(DemoThemeType.light),
            ),
            const SizedBox(width: 8),
            _buildThemeChip(
              context,
              label: 'Dark',
              icon: Icons.dark_mode_outlined,
              isSelected: currentTheme == DemoThemeType.dark,
              onTap: () => onThemeChanged(DemoThemeType.dark),
            ),
            const SizedBox(width: 8),
            _buildThemeChip(
              context,
              label: 'Luxury Gold',
              icon: Icons.stars_rounded,
              isSelected: currentTheme == DemoThemeType.luxury,
              onTap: () => onThemeChanged(DemoThemeType.luxury),
            ),
            const SizedBox(width: 8),
            _buildThemeChip(
              context,
              label: 'Emerald',
              icon: Icons.eco_outlined,
              isSelected: currentTheme == DemoThemeType.emerald,
              onTap: () => onThemeChanged(DemoThemeType.emerald),
            ),
            const SizedBox(width: 16),
            const VerticalDivider(),
            const SizedBox(width: 8),

            // Toggles
            FilterChip(
              label: const Text('Bus Frame'),
              selected: showBusFrame,
              onSelected: onBusFrameChanged,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('Vector Seats'),
              selected: useVectorSeats,
              onSelected: onVectorSeatsChanged,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 8),
            FilterChip(
              label: const Text('Zoom / Pan'),
              selected: enableZoom,
              onSelected: onZoomChanged,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      visualDensity: VisualDensity.compact,
    );
  }
}
