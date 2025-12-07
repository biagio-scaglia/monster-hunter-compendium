import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
import '../../../../shared/widgets/optimized_image.dart';
import '../providers/weapons_provider.dart';
import 'weapon_detail_page.dart';

class WeaponsPage extends StatefulWidget {
  const WeaponsPage({super.key});

  @override
  State<WeaponsPage> createState() => _WeaponsPageState();
}

class _WeaponsPageState extends State<WeaponsPage> {
  late WeaponsProvider provider;

  @override
  void initState() {
    super.initState();
    provider = WeaponsProvider();
    provider.loadWeapons();
  }

  @override
  void dispose() {
    provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weapons'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              provider.refreshWeapons();
            },
          ),
        ],
      ),
      body: ResponsiveContainer(
        child: ListenableBuilder(
          listenable: provider,
          builder: (context, _) {
            if (provider.isLoading && provider.weapons.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (provider.hasError && provider.weapons.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading weapons',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.error ?? 'Unknown error',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        provider.refreshWeapons();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (provider.weapons.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sports_martial_arts,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text('No weapons found'),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => provider.refreshWeapons(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.weapons.length,
                itemBuilder: (context, index) {
                  final weapon = provider.weapons[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: weapon.iconUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: OptimizedImage(
                                imageUrl: weapon.iconUrl,
                                width: 60,
                                height: 60,
                                errorWidget: const Icon(Icons.sports_martial_arts, size: 40),
                              ),
                            )
                          : const Icon(Icons.sports_martial_arts, size: 40),
                      title: Text(
                        weapon.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Type: ${weapon.type}'),
                          Text('Rarity: ${weapon.rarity}'),
                          if (weapon.attack != null && weapon.attack!['display'] != null)
                            Text('Attack: ${weapon.attack!['display']}'),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeaponDetailPage(
                              weaponId: weapon.id,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

