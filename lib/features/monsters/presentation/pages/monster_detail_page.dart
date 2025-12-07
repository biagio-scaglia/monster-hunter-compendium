import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
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
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final loadedMonster = await repository.getMonsterById(widget.monsterId);

      setState(() {
        monster = loadedMonster;
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
        title: const Text('Monster Details'),
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
            const SizedBox(height: 8),
            if (error != null && error!.contains('404'))
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'The monster with ID "${widget.monsterId}" was not found.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadMonster,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

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
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.pets,
              size: 100,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          if (monster!.name.isNotEmpty)
            Text(
              monster!.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange[700],
                  ),
            )
          else
            Text(
              'Unknown Monster',
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
              monster!.elements.join(', '),
              Icons.whatshot,
            ),
          ],
          if (monster!.weaknesses.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Weaknesses',
              monster!.weaknesses.length.toString(),
              Icons.warning,
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

