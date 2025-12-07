import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter/services.dart';
import '../../../../features/home/presentation/pages/home_page.dart';
import '../../../../features/hub/presentation/pages/hub_page.dart';
import '../../../../features/monsters/presentation/pages/monsters_page.dart';
import '../../../../features/weapons/presentation/pages/weapons_page.dart';
import '../../../../features/armor/presentation/pages/armor_page.dart';
import '../../../../features/items/presentation/pages/items_page.dart';
import '../../../../features/skills/presentation/pages/skills_page.dart';
import '../../../../features/locations/presentation/pages/locations_page.dart';
import '../../../../features/armor_sets/presentation/pages/armor_sets_page.dart';
import '../../../../features/charms/presentation/pages/charms_page.dart';
import '../../../../features/decorations/presentation/pages/decorations_page.dart';
import '../../../../features/events/presentation/pages/events_page.dart';
import '../../../../features/info/presentation/pages/info_page.dart';
import '../../../../shared/theme/app_theme.dart';

class MainNavigationPage extends StatefulWidget {
  final VoidCallback? onThemeToggle;
  final bool isDarkMode;

  const MainNavigationPage({
    super.key,
    this.onThemeToggle,
    this.isDarkMode = false,
  });

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomePage(),
    HubPage(),
    MonstersPage(),
    WeaponsPage(),
    ArmorPage(),
  ];

  final List<NavigationItem> navigationItems = const [
    NavigationItem(icon: Icons.home, label: 'Home'),
    NavigationItem(icon: Icons.dashboard, label: 'Hub'),
    NavigationItem(icon: Icons.pets, label: 'Monsters'),
    NavigationItem(icon: Icons.sports_martial_arts, label: 'Weapons'),
    NavigationItem(icon: Icons.shield, label: 'Armor'),
  ];

  void _onItemTapped(int index) {
    if (index != currentIndex && index >= 0 && index < pages.length) {
      HapticFeedback.selectionClick();
      setState(() {
        currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            );
          },
          child: pages[currentIndex],
        ),
      ),
      drawer: _buildDrawer(isDark),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildDrawer(bool isDark) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryButtonGradient,
            ),
            child: DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Monster Hunter',
                    style: AppTheme.titleStyle.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Compendium',
                    style: AppTheme.bodyStyle.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          _buildDrawerItem(
            icon: Icons.home,
            title: 'Home',
            isSelected: currentIndex == 0,
            onTap: () {
              _onItemTapped(0);
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.dashboard,
            title: 'Hub',
            isSelected: currentIndex == 1,
            onTap: () {
              _onItemTapped(1);
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.pets,
            title: 'Monsters',
            isSelected: currentIndex == 2,
            onTap: () {
              _onItemTapped(2);
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.sports_martial_arts,
            title: 'Weapons',
            isSelected: currentIndex == 3,
            onTap: () {
              _onItemTapped(3);
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.shield,
            title: 'Armor',
            isSelected: currentIndex == 4,
            onTap: () {
              _onItemTapped(4);
              Navigator.pop(context);
            },
          ),
          _buildDrawerItem(
            icon: Icons.inventory_2,
            title: 'Items',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ItemsPage(),
                ),
              );
            },
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.stars,
            title: 'Skills',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SkillsPage(),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.checkroom,
            title: 'Armor Sets',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ArmorSetsPage(),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.workspace_premium,
            title: 'Charms',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CharmsPage(),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.diamond,
            title: 'Decorations',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DecorationsPage(),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.map,
            title: 'Locations',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LocationsPage(),
                ),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.event,
            title: 'Events',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventsPage(),
                ),
              );
            },
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.info,
            title: 'Info',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InfoPage(),
                ),
              );
            },
          ),
          if (widget.onThemeToggle != null)
            _buildDrawerItem(
              icon: isDark ? Icons.light_mode : Icons.dark_mode,
              title: isDark ? 'Light Mode' : 'Dark Mode',
              onTap: () {
                Navigator.pop(context);
                widget.onThemeToggle?.call();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppTheme.primaryColor : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppTheme.primaryColor : null,
        ),
      ),
      selected: isSelected,
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: _onItemTapped,
        items: navigationItems.map((item) {
          final index = navigationItems.indexOf(item);
          final isSelected = index == currentIndex;
          return BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: isSelected
                  ? BoxDecoration(
                      gradient: AppTheme.primaryButtonGradient,
                      borderRadius: BorderRadius.circular(8),
                    )
                  : null,
              child: Icon(
                item.icon,
                color: isSelected
                    ? AppTheme.primaryText
                    : Theme.of(context).iconTheme.color,
              ),
            ),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;

  const NavigationItem({
    required this.icon,
    required this.label,
  });
}
