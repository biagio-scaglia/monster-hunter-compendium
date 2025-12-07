import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
import '../../data/repositories/decoration_repository.dart';
import '../../data/models/decoration_model.dart';

class DecorationDetailPage extends StatefulWidget {
  final int decorationId;

  const DecorationDetailPage({
    super.key,
    required this.decorationId,
  });

  @override
  State<DecorationDetailPage> createState() => _DecorationDetailPageState();
}

class _DecorationDetailPageState extends State<DecorationDetailPage> {
  final DecorationRepository repository = DecorationRepository();
  DecorationModel? decoration;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadDecoration();
  }

  Future<void> loadDecoration() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final loadedDecoration = await repository.getDecorationById(widget.decorationId);
      setState(() {
        decoration = loadedDecoration;
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
        title: const Text('Decoration Details'),
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
              'Error Loading Decoration',
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
              onPressed: loadDecoration,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (decoration == null) {
      return const Center(
        child: Text('Decoration not found'),
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
              Icons.diamond,
              size: 100,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            decoration!.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange[700],
                ),
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            'Decoration ID',
            decoration!.id.toString(),
            Icons.tag,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Rarity',
            decoration!.rarity.toString(),
            Icons.star,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Slot',
            decoration!.slot.toString(),
            Icons.settings,
          ),
          if (decoration!.skills.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Skills',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...decoration!.skills.map((skill) {
              final skillData = skill as Map<String, dynamic>;
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.stars),
                  title: Text(skillData['skillName']?.toString() ?? 'Unknown Skill'),
                  subtitle: Text('Level ${skillData['level'] ?? 1}'),
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

