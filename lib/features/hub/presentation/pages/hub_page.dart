import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
import '../../../../features/monsters/presentation/pages/monsters_page.dart';
import '../../../../features/weapons/presentation/pages/weapons_page.dart';
import '../../../../features/armor/presentation/pages/armor_page.dart';
import '../../../../features/armor_sets/presentation/pages/armor_sets_page.dart';
import '../../../../features/items/presentation/pages/items_page.dart';
import '../../../../features/skills/presentation/pages/skills_page.dart';
import '../../../../features/locations/presentation/pages/locations_page.dart';
import '../../../../features/charms/presentation/pages/charms_page.dart';
import '../../../../features/decorations/presentation/pages/decorations_page.dart';
import '../../../../features/events/presentation/pages/events_page.dart';

class HubPage extends StatelessWidget {
  const HubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hub'),
      ),
      body: ResponsiveContainer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Monster Hunter Database',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange[700],
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Explore all available data',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              _buildSectionTitle(context, 'Monsters & Creatures'),
              const SizedBox(height: 16),
              _buildHubCard(
                context,
                title: 'Monsters',
                subtitle: 'Browse all monsters',
                icon: Icons.pets,
                color: Colors.red,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MonstersPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildSectionTitle(context, 'Equipment'),
              const SizedBox(height: 16),
              _buildHubCard(
                context,
                title: 'Weapons',
                subtitle: 'All weapon types and stats',
                icon: Icons.sports_martial_arts,
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WeaponsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildHubCard(
                context,
                title: 'Armor',
                subtitle: 'Armor pieces',
                icon: Icons.shield,
                color: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArmorPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildHubCard(
                context,
                title: 'Armor Sets',
                subtitle: 'Complete armor sets',
                icon: Icons.checkroom,
                color: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArmorSetsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildHubCard(
                context,
                title: 'Items',
                subtitle: 'Consumables and materials',
                icon: Icons.inventory_2,
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ItemsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildHubCard(
                context,
                title: 'Charms',
                subtitle: 'Equipment charms',
                icon: Icons.workspace_premium,
                color: Colors.amber,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CharmsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildHubCard(
                context,
                title: 'Decorations',
                subtitle: 'Skill decorations',
                icon: Icons.diamond,
                color: Colors.purple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DecorationsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildSectionTitle(context, 'Skills & Abilities'),
              const SizedBox(height: 16),
              _buildHubCard(
                context,
                title: 'Skills',
                subtitle: 'All available skills',
                icon: Icons.stars,
                color: Colors.purple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SkillsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildSectionTitle(context, 'World'),
              const SizedBox(height: 16),
              _buildHubCard(
                context,
                title: 'Locations',
                subtitle: 'All game locations',
                icon: Icons.map,
                color: Colors.teal,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LocationsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildSectionTitle(context, 'Events'),
              const SizedBox(height: 16),
              _buildHubCard(
                context,
                title: 'Events',
                subtitle: 'In-game events and quests',
                icon: Icons.event,
                color: Colors.indigo,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EventsPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange[700],
          ),
    );
  }

  Widget _buildHubCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}

