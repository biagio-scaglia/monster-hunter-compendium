import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
import '../../data/repositories/armor_set_repository.dart';
import '../../data/models/armor_set_model.dart';

class ArmorSetDetailPage extends StatefulWidget {
  final int armorSetId;

  const ArmorSetDetailPage({
    super.key,
    required this.armorSetId,
  });

  @override
  State<ArmorSetDetailPage> createState() => _ArmorSetDetailPageState();
}

class _ArmorSetDetailPageState extends State<ArmorSetDetailPage> {
  final ArmorSetRepository repository = ArmorSetRepository();
  ArmorSetModel? armorSet;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadArmorSet();
  }

  Future<void> loadArmorSet() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final loadedArmorSet = await repository.getArmorSetById(widget.armorSetId);
      setState(() {
        armorSet = loadedArmorSet;
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
        title: const Text('Armor Set Details'),
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
              'Error Loading Armor Set',
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
              onPressed: loadArmorSet,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (armorSet == null) {
      return const Center(
        child: Text('Armor set not found'),
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
              Icons.checkroom,
              size: 100,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            armorSet!.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange[700],
                ),
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            'Armor Set ID',
            armorSet!.id.toString(),
            Icons.tag,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Rank',
            armorSet!.rank,
            Icons.star,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Pieces',
            armorSet!.pieces.length.toString(),
            Icons.checkroom,
          ),
          if (armorSet!.bonus != null) ...[
            const SizedBox(height: 24),
            Text(
              'Set Bonus',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (armorSet!.bonus!['name'] != null)
                      Text(
                        armorSet!.bonus!['name'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    if (armorSet!.bonus!['ranks'] != null) ...[
                      const SizedBox(height: 16),
                      ...(armorSet!.bonus!['ranks'] as List).map((rank) {
                        final rankData = rank as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '${rankData['pieces']} pieces: ${rankData['skill']?['skillName'] ?? 'Bonus'}',
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ),
          ],
          if (armorSet!.pieces.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Armor Pieces',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...armorSet!.pieces.map((piece) {
              final pieceData = piece as Map<String, dynamic>;
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.shield),
                  title: Text(pieceData['name']?.toString() ?? 'Unknown'),
                  subtitle: Text('Type: ${pieceData['type'] ?? 'Unknown'}'),
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
}

