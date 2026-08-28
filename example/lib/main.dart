import 'package:bus_seat_plan/bus_seat_plan.dart';
import 'package:flutter/material.dart';
import 'demo_layouts.dart';
import 'widgets/seat_summary_sheet.dart';
import 'widgets/theme_selector.dart';

void main() {
  runApp(const BusSeatPlanShowcaseApp());
}

class BusSeatPlanShowcaseApp extends StatefulWidget {
  const BusSeatPlanShowcaseApp({super.key});

  @override
  State<BusSeatPlanShowcaseApp> createState() => _BusSeatPlanShowcaseAppState();
}

class _BusSeatPlanShowcaseAppState extends State<BusSeatPlanShowcaseApp> {
  DemoThemeType _selectedTheme = DemoThemeType.light;

  ThemeData _getMaterialTheme() {
    switch (_selectedTheme) {
      case DemoThemeType.light:
        return ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorSchemeSeed: const Color(0xFF2563EB),
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        );
      case DemoThemeType.dark:
        return ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: const Color(0xFF3B82F6),
          scaffoldBackgroundColor: const Color(0xFF0F172A),
        );
      case DemoThemeType.luxury:
        return ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: const Color(0xFFD4AF37),
          scaffoldBackgroundColor: const Color(0xFF0B132B),
        );
      case DemoThemeType.emerald:
        return ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorSchemeSeed: const Color(0xFF16A34A),
          scaffoldBackgroundColor: const Color(0xFFF0FDF4),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Seat Plan 3.0 Playground',
      debugShowCheckedModeBanner: false,
      theme: _getMaterialTheme(),
      home: SeatPlanPlaygroundScreen(
        currentTheme: _selectedTheme,
        onThemeChanged: (theme) => setState(() => _selectedTheme = theme),
      ),
    );
  }
}

class SeatPlanPlaygroundScreen extends StatefulWidget {
  final DemoThemeType currentTheme;
  final ValueChanged<DemoThemeType> onThemeChanged;

  const SeatPlanPlaygroundScreen({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  State<SeatPlanPlaygroundScreen> createState() =>
      _SeatPlanPlaygroundScreenState();
}

class _SeatPlanPlaygroundScreenState extends State<SeatPlanPlaygroundScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late SeatPlanController _controller;

  bool _showBusFrame = true;
  bool _useVectorSeats = true;
  bool _enableZoom = false;

  final List<SeatLayout> _layouts = [
    DemoLayouts.standardExpress(),
    DemoLayouts.vipExecutive(),
    DemoLayouts.royalSleeper(),
    DemoLayouts.doubleDeckerCruiser(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _layouts.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _controller.clearSelection();
      }
    });

    _controller = SeatPlanController(
      maxSelectedSeats: 4,
      onMaxSeatsReached: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Maximum selection limit of 4 seats reached.'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  BusSeatThemeData _getBusSeatTheme() {
    BusSeatThemeData baseTheme;
    switch (widget.currentTheme) {
      case DemoThemeType.light:
        baseTheme = BusSeatThemeData.light();
        break;
      case DemoThemeType.dark:
        baseTheme = BusSeatThemeData.dark();
        break;
      case DemoThemeType.luxury:
        baseTheme = BusSeatThemeData.luxury();
        break;
      case DemoThemeType.emerald:
        baseTheme = BusSeatThemeData.emerald();
        break;
    }

    return baseTheme.copyWith(
      showBusFrame: _showBusFrame,
      useVectorSeats: _useVectorSeats,
    );
  }

  void _handleBooking() {
    final count = _controller.selectedCount;
    final seatNumbers = _controller.selectedSeats.map((s) => s.label).join(', ');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.green),
            SizedBox(width: 8),
            Text('Booking Confirmed'),
          ],
        ),
        content: Text(
          'Successfully reserved $count seats ($seatNumbers) for a total of '
          '\$${_controller.totalPrice > 0 ? _controller.totalPrice.toStringAsFixed(2) : (count * 25.0).toStringAsFixed(2)}.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _controller.clearSelection();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _getBusSeatTheme();

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bus Seat Plan 3.0',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              'High-Performance & Modern UI Architecture',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(92),
          child: Column(
            children: [
              ThemeSelector(
                currentTheme: widget.currentTheme,
                onThemeChanged: widget.onThemeChanged,
                showBusFrame: _showBusFrame,
                onBusFrameChanged: (val) => setState(() => _showBusFrame = val),
                useVectorSeats: _useVectorSeats,
                onVectorSeatsChanged: (val) =>
                    setState(() => _useVectorSeats = val),
                enableZoom: _enableZoom,
                onZoomChanged: (val) => setState(() => _enableZoom = val),
              ),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: const [
                  Tab(text: '2+2 Express'),
                  Tab(text: '2+1 VIP Club'),
                  Tab(text: '1+1+1 Sleeper'),
                  Tab(text: 'Double Decker'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _layouts.map((layout) {
          return BusSeatPlan(
            seatLayout: layout,
            controller: _controller,
            theme: theme,
            enableInteractiveViewer: _enableZoom,
            onSeatTap: (seat) {
              // Tap feedback
            },
          );
        }).toList(),
      ),
      bottomNavigationBar: SeatSummarySheet(
        controller: _controller,
        theme: theme,
        onBookNow: _handleBooking,
      ),
    );
  }
}
