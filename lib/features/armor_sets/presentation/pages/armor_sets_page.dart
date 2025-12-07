import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
import '../providers/armor_sets_provider.dart';
import 'armor_set_detail_page.dart';

class ArmorSetsPage extends StatefulWidget {
  const ArmorSetsPage({super.key});

  @override
  State<ArmorSetsPage> createState() => _ArmorSetsPageState();
}

class _ArmorSetsPageState extends State<ArmorSetsPage> {
  late ArmorSetsProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ArmorSetsProvider();
    provider.loadArmorSets();
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
        title: const Text('Armor Sets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              provider.refreshArmorSets();
            },
          ),
        ],
      ),
      body: ResponsiveContainer(
        child: ListenableBuilder(
          listenable: provider,
          builder: (context, _) {
            if (provider.isLoading && provider.armorSets.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (provider.hasError && provider.armorSets.isEmpty) {
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
                      'Error loading armor sets',
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
                        provider.refreshArmorSets();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (provider.armorSets.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.checkroom,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text('No armor sets found'),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => provider.refreshArmorSets(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.armorSets.length,
                itemBuilder: (context, index) {
                  final armorSet = provider.armorSets[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.checkroom, size: 40),
                      title: Text(
                        armorSet.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rank: ${armorSet.rank}'),
                          Text('Pieces: ${armorSet.pieces.length}'),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArmorSetDetailPage(
                              armorSetId: armorSet.id,
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

