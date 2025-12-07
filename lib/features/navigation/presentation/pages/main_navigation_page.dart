import 'package:flutter/material.dart';
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

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: pages[currentIndex],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepOrange,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monster Hunter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Database',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              selected: currentIndex == 0,
              onTap: () {
                setState(() {
                  currentIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Hub'),
              selected: currentIndex == 1,
              onTap: () {
                setState(() {
                  currentIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.pets),
              title: const Text('Monsters'),
              selected: currentIndex == 2,
              onTap: () {
                setState(() {
                  currentIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sports_martial_arts),
              title: const Text('Weapons'),
              selected: currentIndex == 3,
              onTap: () {
                setState(() {
                  currentIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shield),
              title: const Text('Armor'),
              selected: currentIndex == 4,
              onTap: () {
                setState(() {
                  currentIndex = 4;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text('Items'),
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
            ListTile(
              leading: const Icon(Icons.stars),
              title: const Text('Skills'),
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
            ListTile(
              leading: const Icon(Icons.checkroom),
              title: const Text('Armor Sets'),
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
            ListTile(
              leading: const Icon(Icons.workspace_premium),
              title: const Text('Charms'),
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
            ListTile(
              leading: const Icon(Icons.diamond),
              title: const Text('Decorations'),
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
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Locations'),
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
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Events'),
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
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Info'),
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
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          if (index >= 0 && index < pages.length) {
            setState(() {
              currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Hub',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Monsters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_martial_arts),
            label: 'Weapons',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'Armor',
          ),
        ],
      ),
    );
  }
}

