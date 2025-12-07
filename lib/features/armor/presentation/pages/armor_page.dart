import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
import '../../../../shared/widgets/optimized_image.dart';
import '../providers/armor_provider.dart';
import 'armor_detail_page.dart';

class ArmorPage extends StatefulWidget {
  const ArmorPage({super.key});

  @override
  State<ArmorPage> createState() => _ArmorPageState();
}

class _ArmorPageState extends State<ArmorPage> {
  late ArmorProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ArmorProvider();
    provider.loadArmor();
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
        title: const Text('Armor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              provider.refreshArmor();
            },
          ),
        ],
      ),
      body: ResponsiveContainer(
        child: ListenableBuilder(
          listenable: provider,
          builder: (context, _) {
            if (provider.isLoading && provider.armor.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (provider.hasError && provider.armor.isEmpty) {
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
                      'Error loading armor',
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
                        provider.refreshArmor();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (provider.armor.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shield,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text('No armor found'),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => provider.refreshArmor(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.armor.length,
                itemBuilder: (context, index) {
                  final armor = provider.armor[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: armor.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: OptimizedImage(
                                imageUrl: armor.imageUrl,
                                width: 60,
                                height: 60,
                                errorWidget: const Icon(Icons.shield, size: 40),
                              ),
                            )
                          : const Icon(Icons.shield, size: 40),
                      title: Text(
                        armor.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Type: ${armor.type}'),
                          Text('Rank: ${armor.rank}'),
                          Text('Rarity: ${armor.rarity}'),
                          if (armor.defense != null && armor.defense!['base'] != null)
                            Text('Defense: ${armor.defense!['base']}'),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArmorDetailPage(
                              armorId: armor.id,
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

