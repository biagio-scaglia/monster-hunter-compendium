import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
import '../../data/repositories/charm_repository.dart';
import '../../data/models/charm_model.dart';

class CharmDetailPage extends StatefulWidget {
  final int charmId;

  const CharmDetailPage({
    super.key,
    required this.charmId,
  });

  @override
  State<CharmDetailPage> createState() => _CharmDetailPageState();
}

class _CharmDetailPageState extends State<CharmDetailPage> {
  final CharmRepository repository = CharmRepository();
  CharmModel? charm;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadCharm();
  }

  Future<void> loadCharm() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final loadedCharm = await repository.getCharmById(widget.charmId);
      setState(() {
        charm = loadedCharm;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charm Details'),
      ),
      body: ResponsiveContainer(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
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
              'Error Loading Charm',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                error ?? 'Unknown error occurred',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadCharm,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (charm == null) {
      return const Center(
        child: Text('Charm not found'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.workspace_premium,
              size: 100,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            charm!.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange[700],
                ),
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            'Charm ID',
            charm!.id.toString(),
            Icons.tag,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Ranks',
            charm!.ranks.length.toString(),
            Icons.star,
          ),
          if (charm!.ranks.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Rank Details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...charm!.ranks.asMap().entries.map((entry) {
              final rank = entry.value as Map<String, dynamic>;
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Level ${rank['level'] ?? entry.key + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (rank['rarity'] != null) ...[
                        const SizedBox(height: 4),
                        Text('Rarity: ${rank['rarity']}'),
                      ],
                      if (rank['skills'] != null && (rank['skills'] as List).isNotEmpty) ...[
                        const SizedBox(height: 8),
                        ...(rank['skills'] as List).map((skill) {
                          final skillData = skill as Map<String, dynamic>;
                          final skillName = skillData['skillName']?.toString() ?? 'Skill';
                          final level = skillData['level']?.toString() ?? '1';
                          final description = skillData['description']?.toString() ?? '';
                          return Card(
                            elevation: 1,
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$skillName (Level $level)',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  if (description.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(description, style: const TextStyle(fontSize: 12)),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                      // Mostra il crafting se disponibile
                      if (rank['crafting'] != null) ...[
                        const SizedBox(height: 16),
                        _buildCraftingInfo(rank['crafting'] as Map<String, dynamic>),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.deepOrange[700]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCraftingInfo(Map<String, dynamic> crafting) {
    final materials = crafting['materials'] as List<dynamic>?;
    final craftable = crafting['craftable'] == true;
    
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Crafting',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text('Craftable: ${craftable ? 'Yes' : 'No'}'),
            if (materials != null && materials.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Materials',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              ...materials.map((material) {
                final materialData = material as Map<String, dynamic>;
                final item = materialData['item'] as Map<String, dynamic>?;
                final quantity = materialData['quantity']?.toString() ?? '0';
                final itemName = item?['name']?.toString() ?? 'Unknown';
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.inventory_2),
                    title: Text(itemName),
                    subtitle: Text('Quantity: $quantity'),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}

