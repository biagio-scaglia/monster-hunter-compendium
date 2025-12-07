import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
import '../../../../shared/widgets/optimized_image.dart';
import '../../data/repositories/weapon_repository.dart';
import '../../data/models/weapon_model.dart';

class WeaponDetailPage extends StatefulWidget {
  final int weaponId;

  const WeaponDetailPage({
    super.key,
    required this.weaponId,
  });

  @override
  State<WeaponDetailPage> createState() => _WeaponDetailPageState();
}

class _WeaponDetailPageState extends State<WeaponDetailPage> {
  final WeaponRepository repository = WeaponRepository();
  WeaponModel? weapon;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadWeapon();
  }

  Future<void> loadWeapon() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final loadedWeapon = await repository.getWeaponById(widget.weaponId);
      setState(() {
        weapon = loadedWeapon;
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
        title: const Text('Weapon Details'),
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
              'Error Loading Weapon',
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
              onPressed: loadWeapon,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (weapon == null) {
      return const Center(
        child: Text('Weapon not found'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (weapon!.imageUrl != null)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: OptimizedImage(
                  imageUrl: weapon!.imageUrl,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
            )
          else if (weapon!.iconUrl != null)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: OptimizedImage(
                  imageUrl: weapon!.iconUrl,
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
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
                Icons.sports_martial_arts,
                size: 100,
                color: Colors.grey,
              ),
            ),
          const SizedBox(height: 24),
          Text(
            weapon!.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange[700],
                ),
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            'Weapon ID',
            weapon!.id.toString(),
            Icons.tag,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Type',
            weapon!.type,
            Icons.category,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Rarity',
            weapon!.rarity.toString(),
            Icons.star,
          ),
          if (weapon!.attack != null) ...[
            const SizedBox(height: 16),
            if (weapon!.attack!['display'] != null)
              _buildInfoCard(
                'Attack (Display)',
                weapon!.attack!['display'].toString(),
                Icons.sports_martial_arts,
              ),
            if (weapon!.attack!['raw'] != null) ...[
              const SizedBox(height: 16),
              _buildInfoCard(
                'Attack (Raw)',
                weapon!.attack!['raw'].toString(),
                Icons.sports_martial_arts,
              ),
            ],
          ],
          if (weapon!.damageType != null && weapon!.damageType!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Damage Type',
              weapon!.damageType!,
              Icons.flash_on,
            ),
          ],
          if (weapon!.elements != null && weapon!.elements!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Elements',
              weapon!.elements!.length.toString(),
              Icons.whatshot,
            ),
          ],
          if (weapon!.slots != null && weapon!.slots!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Decoration Slots',
              weapon!.slots!.length.toString(),
              Icons.settings,
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

