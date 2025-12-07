import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
import '../../../../shared/widgets/optimized_image.dart';
import '../../data/repositories/armor_repository.dart';
import '../../data/models/armor_model.dart';

class ArmorDetailPage extends StatefulWidget {
  final int armorId;

  const ArmorDetailPage({
    super.key,
    required this.armorId,
  });

  @override
  State<ArmorDetailPage> createState() => _ArmorDetailPageState();
}

class _ArmorDetailPageState extends State<ArmorDetailPage> {
  final ArmorRepository repository = ArmorRepository();
  ArmorModel? armor;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadArmor();
  }

  Future<void> loadArmor() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final loadedArmor = await repository.getArmorById(widget.armorId);
      setState(() {
        armor = loadedArmor;
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
        title: const Text('Armor Details'),
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
              'Error Loading Armor',
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
              onPressed: loadArmor,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (armor == null) {
      return const Center(
        child: Text('Armor not found'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (armor!.imageUrl != null)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: OptimizedImage(
                  imageUrl: armor!.imageUrl,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.shield,
                size: 100,
                color: Colors.grey,
              ),
            ),
          const SizedBox(height: 24),
          Text(
            armor!.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange[700],
                ),
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            'Armor ID',
            armor!.id.toString(),
            Icons.tag,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Type',
            armor!.type,
            Icons.category,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Rank',
            armor!.rank,
            Icons.star,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Rarity',
            armor!.rarity.toString(),
            Icons.star_border,
          ),
          if (armor!.defense != null) ...[
            const SizedBox(height: 16),
            if (armor!.defense!['base'] != null)
              _buildInfoCard(
                'Defense (Base)',
                armor!.defense!['base'].toString(),
                Icons.shield,
              ),
            if (armor!.defense!['max'] != null) ...[
              const SizedBox(height: 16),
              _buildInfoCard(
                'Defense (Max)',
                armor!.defense!['max'].toString(),
                Icons.shield,
              ),
            ],
            if (armor!.defense!['augmented'] != null) ...[
              const SizedBox(height: 16),
              _buildInfoCard(
                'Defense (Augmented)',
                armor!.defense!['augmented'].toString(),
                Icons.shield,
              ),
            ],
          ],
          if (armor!.resistances != null) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Resistances',
              'Fire: ${armor!.resistances!['fire'] ?? 0}, Water: ${armor!.resistances!['water'] ?? 0}, Ice: ${armor!.resistances!['ice'] ?? 0}, Thunder: ${armor!.resistances!['thunder'] ?? 0}, Dragon: ${armor!.resistances!['dragon'] ?? 0}',
              Icons.whatshot,
            ),
          ],
          if (armor!.slots != null && armor!.slots!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Decoration Slots',
              armor!.slots!.length.toString(),
              Icons.settings,
            ),
          ],
          if (armor!.skills != null && armor!.skills!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Skills',
              armor!.skills!.length.toString(),
              Icons.stars,
            ),
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

