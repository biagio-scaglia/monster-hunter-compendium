import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
import '../../../../shared/utils/ailment_helper.dart';
import '../../data/repositories/ailment_repository.dart';
import '../../data/models/ailment_model.dart';

class AilmentDetailPage extends StatefulWidget {
  final int ailmentId;

  const AilmentDetailPage({
    super.key,
    required this.ailmentId,
  });

  @override
  State<AilmentDetailPage> createState() => _AilmentDetailPageState();
}

class _AilmentDetailPageState extends State<AilmentDetailPage> {
  final AilmentRepository repository = AilmentRepository();
  AilmentModel? ailment;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadAilment();
  }

  Future<void> loadAilment() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final loadedAilment = await repository.getAilmentById(widget.ailmentId);
      setState(() {
        ailment = loadedAilment;
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
        title: const Text('Ailment Details'),
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
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error Loading Ailment', style: Theme.of(context).textTheme.titleLarge),
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
              onPressed: loadAilment,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (ailment == null) {
      return const Center(
        child: Text('Ailment not found'),
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
              color: AilmentHelper.getAilmentColor(ailment!.name).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              AilmentHelper.getAilmentIcon(ailment!.name),
              size: 100,
              color: AilmentHelper.getAilmentColor(ailment!.name),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            ailment!.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange[700],
                ),
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            'Description',
            ailment!.description,
            Icons.description,
          ),
          // Mostra recovery solo se ha dati
          if (_hasRecoveryData(ailment!.recovery)) ...[
            const SizedBox(height: 24),
            Text(
              'Recovery',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildRecoveryInfo(ailment!.recovery!),
          ],
          // Mostra protection solo se ha dati
          if (_hasProtectionData(ailment!.protection)) ...[
            const SizedBox(height: 24),
            Text(
              'Protection',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildProtectionInfo(ailment!.protection!),
          ],
        ],
      ),
    );
  }

  // Controlla se recovery ha dati da mostrare
  bool _hasRecoveryData(Map<String, dynamic>? recovery) {
    if (recovery == null) return false;
    final actions = recovery['actions'] as List?;
    final items = recovery['items'] as List?;
    final hasActions = actions != null && actions.isNotEmpty;
    final hasItems = items != null && items.isNotEmpty;
    return hasActions || hasItems;
  }

  // Controlla se protection ha dati da mostrare
  bool _hasProtectionData(Map<String, dynamic>? protection) {
    if (protection == null) return false;
    final items = protection['items'] as List?;
    final skills = protection['skills'] as List?;
    final hasItems = items != null && items.isNotEmpty;
    final hasSkills = skills != null && skills.isNotEmpty;
    return hasItems || hasSkills;
  }

  Widget _buildRecoveryInfo(Map<String, dynamic> recovery) {
    final hasActions = recovery['actions'] != null && (recovery['actions'] as List).isNotEmpty;
    final hasItems = recovery['items'] != null && (recovery['items'] as List).isNotEmpty;
    
    // Se non c'è niente, non mostrare nulla
    if (!hasActions && !hasItems) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasActions) ...[
              const Text(
                'Actions',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ...(recovery['actions'] as List).map((action) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Text(action.toString()),
                    ],
                  ),
                );
              }),
              if (hasItems) const SizedBox(height: 16),
            ],
            if (hasItems) ...[
              const Text(
                'Items',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ...(recovery['items'] as List).map((item) {
                final itemData = item as Map<String, dynamic>;
                final name = itemData['name']?.toString() ?? 'Unknown';
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.inventory_2),
                    title: Text(name),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProtectionInfo(Map<String, dynamic> protection) {
    final hasItems = protection['items'] != null && (protection['items'] as List).isNotEmpty;
    final hasSkills = protection['skills'] != null && (protection['skills'] as List).isNotEmpty;
    
    // Se non c'è niente, non mostrare nulla
    if (!hasItems && !hasSkills) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasItems) ...[
              const Text(
                'Items',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ...(protection['items'] as List).map((item) {
                final itemData = item as Map<String, dynamic>;
                final name = itemData['name']?.toString() ?? 'Unknown';
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.inventory_2),
                    title: Text(name),
                  ),
                );
              }),
              if (hasSkills) const SizedBox(height: 16),
            ],
            if (hasSkills) ...[
              const Text(
                'Skills',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              ...(protection['skills'] as List).map((skill) {
                final skillData = skill as Map<String, dynamic>;
                final name = skillData['name']?.toString() ?? 'Unknown';
                final description = skillData['description']?.toString() ?? '';
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.stars, color: Colors.amber),
                    title: Text(name),
                    subtitle: description.isNotEmpty ? Text(description) : null,
                  ),
                );
              }),
            ],
          ],
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
                  Text(content, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

