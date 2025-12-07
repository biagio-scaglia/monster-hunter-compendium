import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
import '../../../../shared/widgets/optimized_image.dart';
import '../../../../core/constants/api_constants.dart';
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
          // Mostra le immagini maschili e femminili se disponibili
          _buildArmorSetImages(),
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
              final assets = pieceData['assets'] as Map<String, dynamic>?;
              final imageMale = assets?['imageMale'] as String?;
              final imageFemale = assets?['imageFemale'] as String?;
              
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: _buildPieceImage(imageMale, imageFemale),
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

  // Costruisce le immagini dell'armor set (maschile e femminile)
  Widget _buildArmorSetImages() {
    if (armorSet == null || armorSet!.pieces.isEmpty) {
      return Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(
            Icons.checkroom,
            size: 100,
            color: Colors.grey,
          ),
        ),
      );
    }

    // Prendi le immagini dal primo pezzo dell'armor set
    final firstPiece = armorSet!.pieces.first as Map<String, dynamic>;
    final assets = firstPiece['assets'] as Map<String, dynamic>?;
    final imageMale = _getAbsoluteUrl(assets?['imageMale'] as String?);
    final imageFemale = _getAbsoluteUrl(assets?['imageFemale'] as String?);

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
            Icons.checkroom,
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

  // Costruisce l'immagine per un singolo pezzo (mostra maschile se disponibile, altrimenti femminile)
  Widget _buildPieceImage(String? imageMale, String? imageFemale) {
    final imageUrl = _getAbsoluteUrl(imageMale ?? imageFemale);
    
    if (imageUrl == null) {
      return const Icon(Icons.shield, size: 40);
    }
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: OptimizedImage(
        imageUrl: imageUrl,
        width: 50,
        height: 50,
        fit: BoxFit.contain,
      ),
    );
  }

  // Converte un URL relativo in assoluto
  String? _getAbsoluteUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    return ApiConstants.getAbsoluteImageUrl(url);
  }
}

