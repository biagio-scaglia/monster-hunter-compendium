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
          // Mostra le immagini maschili e femminili se disponibili
          _buildArmorImages(),
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
          // Mostra le skill con dettagli
          if (armor!.skills != null && armor!.skills!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Skills',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...armor!.skills!.map((skill) {
              final skillData = skill as Map<String, dynamic>;
              final skillName = skillData['skillName']?.toString() ?? 'Unknown';
              final level = skillData['level']?.toString() ?? '0';
              final description = skillData['description']?.toString() ?? '';
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$skillName (Level $level)',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(description),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ],
          // Mostra gli attributes
          if (armor!.attributes != null && armor!.attributes!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Attributes',
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
                  children: armor!.attributes!.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            '${entry.key}: ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(entry.value.toString()),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
          // Mostra il crafting
          if (armor!.crafting != null) ...[
            const SizedBox(height: 24),
            Text(
              'Crafting Materials',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildCraftingMaterials(armor!.crafting!),
          ],
        ],
      ),
    );
  }

  Widget _buildArmorImages() {
    final imageMale = armor!.imageMaleUrl;
    final imageFemale = armor!.imageFemaleUrl;

    // Se non ci sono immagini, mostra un'icona
    if (imageMale == null && imageFemale == null) {
      return Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(
            Icons.shield,
            size: 100,
            color: Colors.grey,
          ),
        ),
      );
    }

    // Mostra entrambe le immagini se disponibili
    return Column(
      children: [
        if (imageMale != null) ...[
          Text(
            'Male',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: OptimizedImage(
                imageUrl: imageMale,
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (imageFemale != null) ...[
          Text(
            'Female',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: OptimizedImage(
                imageUrl: imageFemale,
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCraftingMaterials(Map<String, dynamic> crafting) {
    final materials = crafting['materials'] as List<dynamic>?;
    
    if (materials == null || materials.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No crafting materials available'),
        ),
      );
    }

    return Column(
      children: materials.map((material) {
        final materialData = material as Map<String, dynamic>;
        final item = materialData['item'] as Map<String, dynamic>?;
        final quantity = materialData['quantity']?.toString() ?? '0';
        final itemName = item?['name']?.toString() ?? 'Unknown';
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.inventory_2),
            title: Text(itemName),
            subtitle: Text('Quantity: $quantity'),
          ),
        );
      }).toList(),
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

