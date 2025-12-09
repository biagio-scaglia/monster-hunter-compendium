import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
import '../../../../shared/widgets/optimized_image.dart';
import '../../../../shared/utils/element_helper.dart';
import '../../data/repositories/monster_repository.dart';
import '../../data/models/monster_model.dart';

class MonsterDetailPage extends StatefulWidget {
  final int monsterId;

  const MonsterDetailPage({
    super.key,
    required this.monsterId,
  });

  @override
  State<MonsterDetailPage> createState() => _MonsterDetailPageState();
}

class _MonsterDetailPageState extends State<MonsterDetailPage> {
  final MonsterRepository repository = MonsterRepository();
  MonsterModel? monster;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadMonster();
  }

  Future<void> loadMonster() async {
    // Inizia il caricamento
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // Carica il mostro dal repository
      final loadedMonster = await repository.getMonsterById(widget.monsterId);

      // Salva il mostro caricato
      setState(() {
        monster = loadedMonster;
        isLoading = false;
      });
    } catch (e) {
      // Se c'è un errore, salvalo e ferma il caricamento
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      setState(() {
        error = errorMessage;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monster Details'),
      ),
      body: ResponsiveContainer(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    // Mostra il caricamento
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Mostra l'errore se c'è
    if (error != null) {
      final isNotFoundError = error!.contains('404');
      
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
              'Error Loading Monster',
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
            if (isNotFoundError) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'The monster with ID "${widget.monsterId}" was not found.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadMonster,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Se il mostro non esiste, mostra un messaggio
    if (monster == null) {
      return const Center(
        child: Text('Monster not found'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mostra l'immagine del mostro se disponibile
          _buildMonsterImage(),
          const SizedBox(height: 24),
          // Mostra il nome del mostro o "Unknown Monster" se non c'è
          Text(
            monster!.name.isNotEmpty ? monster!.name : 'Unknown Monster',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange[700],
                ),
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            'Monster ID',
            monster!.id.toString(),
            Icons.tag,
          ),
          const SizedBox(height: 16),
          if (monster!.type.isNotEmpty)
            _buildInfoCard(
              'Type',
              monster!.type,
              Icons.category,
            ),
          if (monster!.species.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Species',
              monster!.species,
              Icons.pets,
            ),
          ],
          if (monster!.description != null && monster!.description!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Description',
              monster!.description!,
              Icons.description,
            ),
          ],
          if (monster!.elements.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Elements',
              ElementHelper.getElementsWithEmoji(monster!.elements),
              Icons.whatshot,
            ),
          ],
          // Mostra le debolezze con dettagli
          if (monster!.weaknesses.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Weaknesses',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...monster!.weaknesses.map((weakness) {
              final weaknessData = weakness as Map<String, dynamic>;
              final element = weaknessData['element']?.toString() ?? 'Unknown';
              final stars = weaknessData['stars']?.toString() ?? '0';
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Text(
                    ElementHelper.getElementEmoji(element),
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(ElementHelper.getElementWithEmoji(element)),
                  subtitle: Text('${stars} ⭐'),
                ),
              );
            }),
          ],
          // Mostra le resistenze
          if (monster!.resistances.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Resistances',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...monster!.resistances.map((resistance) {
              final resistanceData = resistance as Map<String, dynamic>;
              final element = resistanceData['element']?.toString() ?? 'Unknown';
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Text(
                    ElementHelper.getElementEmoji(element),
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(ElementHelper.getElementWithEmoji(element)),
                  trailing: const Icon(Icons.shield, color: Colors.blue),
                ),
              );
            }),
          ],
          // Mostra gli ailments
          if (monster!.ailments.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Ailments',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...monster!.ailments.map((ailment) {
              final ailmentData = ailment as Map<String, dynamic>;
              final name = ailmentData['name']?.toString() ?? 'Unknown';
              final description = ailmentData['description']?.toString() ?? '';
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
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
          // Mostra le location
          if (monster!.locations.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Locations',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...monster!.locations.map((location) {
              final locationData = location as Map<String, dynamic>;
              final name = locationData['name']?.toString() ?? 'Unknown';
              final zoneCount = locationData['zoneCount']?.toString() ?? '0';
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.map, color: Colors.green),
                  title: Text(name),
                  subtitle: Text('$zoneCount zones'),
                ),
              );
            }),
          ],
          // Mostra i rewards
          if (monster!.rewards.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Rewards',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...monster!.rewards.map((reward) {
              final rewardData = reward as Map<String, dynamic>;
              final item = rewardData['item'] as Map<String, dynamic>?;
              final itemName = item?['name']?.toString() ?? 'Unknown Item';
              final conditions = rewardData['conditions'] as List<dynamic>?;
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.star, color: Colors.amber),
                  title: Text(itemName),
                  subtitle: conditions != null && conditions.isNotEmpty
                      ? Text('${conditions.length} condition(s)')
                      : null,
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildMonsterImage() {
    // Prima controlla se esiste un'immagine locale
    if (monster!.hasLocalImage && monster!.localImagePath != null) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            monster!.localImagePath!,
            width: 300,
            height: 300,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // Se l'immagine locale non viene caricata, usa l'immagine dell'API
              if (monster!.imageUrl != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: OptimizedImage(
                    imageUrl: monster!.imageUrl,
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                );
              }
              if (monster!.iconUrl != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: OptimizedImage(
                    imageUrl: monster!.iconUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                );
              }
              return Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.pets,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
    
    // Se c'è un'immagine dall'API, usala
    if (monster!.imageUrl != null) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: OptimizedImage(
            imageUrl: monster!.imageUrl,
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
      );
    }
    
    // Se c'è solo un'icona, usala
    if (monster!.iconUrl != null) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: OptimizedImage(
            imageUrl: monster!.iconUrl,
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        ),
      );
    }
    
    // Se non c'è nessuna immagine, mostra un'icona di default
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(
          Icons.pets,
          size: 100,
          color: Colors.grey,
        ),
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

