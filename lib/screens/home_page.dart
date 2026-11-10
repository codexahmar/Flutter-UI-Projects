import 'package:flutter/material.dart';
import '../data/pinterest_data.dart';
import '../widgets/pinterest_nav_bar.dart';
import '../widgets/create_pin_modal.dart';
import 'pinterest_home_screen.dart';
import 'pinterest_search_screen.dart';
import 'pinterest_updates_screen.dart';
import 'pinterest_profile_screen.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final ThemeMode themeMode;

  const HomePage({
    super.key,
    required this.onThemeToggle,
    required this.themeMode,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late List<PinItem> _pins;

  @override
  void initState() {
    super.initState();
    _pins = PinterestData.getInitialPins();
  }

  void _onNavTapped(int index) {
    if (index == 2) {
      // Tap on "+" Create action opens create pin bottom sheet modal
      CreatePinModal.show(context);
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onToggleSave() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Map 5 tab indexes to view bodies (Index 2 is modal, so we have 4 views)
    int viewIndex = _selectedIndex;
    if (viewIndex > 2) {
      viewIndex = _selectedIndex - 1; // 3 -> 2 (Updates), 4 -> 3 (Profile)
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: IndexedStack(
          index: viewIndex,
          children: [
            // Tab 0: Home (Pinterest Staggered Masonry Feed)
            PinterestHomeScreen(
              pins: _pins,
              onToggleSave: _onToggleSave,
              onCreateTap: () => CreatePinModal.show(context),
              onChatTap: () => setState(() => _selectedIndex = 3),
            ),

            // Tab 1: Search & Explore
            PinterestSearchScreen(
              pins: _pins,
              onToggleSave: _onToggleSave,
            ),

            // Tab 3: Updates
            const PinterestUpdatesScreen(),

            // Tab 4: Profile
            PinterestProfileScreen(
              themeMode: widget.themeMode,
              onThemeToggle: widget.onThemeToggle,
              pins: _pins,
              onToggleSave: _onToggleSave,
            ),
          ],
        ),
      ),
      bottomNavigationBar: PinterestNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}
