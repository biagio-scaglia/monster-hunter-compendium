import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
import '../../../../shared/widgets/optimized_image.dart';
import '../../../../shared/utils/element_helper.dart';
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
    // Inizia il caricamento
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // Carica l'arma dal repository
      final loadedWeapon = await repository.getWeaponById(widget.weaponId);
      
      // Salva l'arma caricata
      setState(() {
        weapon = loadedWeapon;
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
        title: const Text('Weapon Details'),
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

    // Se l'arma non esiste, mostra un messaggio
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
          // Mostra l'immagine dell'arma se disponibile, altrimenti mostra un'icona
          _buildWeaponImage(),
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
          // Mostra le informazioni sull'attacco se disponibili
          if (weapon!.attack != null) ...[
            if (weapon!.attack!['display'] != null) ...[
              const SizedBox(height: 16),
              _buildInfoCard(
                'Attack (Display)',
                weapon!.attack!['display'].toString(),
                Icons.sports_martial_arts,
              ),
            ],
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
          // Mostra gli elementi con dettagli
          if (weapon!.elements != null && weapon!.elements!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Elements',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...weapon!.elements!.map((element) {
              final elementData = element as Map<String, dynamic>;
              final type = elementData['type']?.toString() ?? 'Unknown';
              final damage = elementData['damage']?.toString() ?? '0';
              final hidden = elementData['hidden'] == true;
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Text(
                    ElementHelper.getElementEmoji(type),
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(ElementHelper.getElementWithEmoji(type)),
                  subtitle: Text('Damage: $damage${hidden ? ' (Hidden)' : ''}'),
                ),
              );
            }),
          ],
          // Mostra gli slot delle decorazioni
          if (weapon!.slots != null && weapon!.slots!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Decoration Slots',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...weapon!.slots!.map((slot) {
              final slotData = slot as Map<String, dynamic>;
              final rank = slotData['rank']?.toString() ?? '0';
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.settings, color: Colors.blue),
                  title: Text('Rank $rank'),
                ),
              );
            }),
          ],
          // Mostra la durabilità
          if (weapon!.durability != null && weapon!.durability!.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text(
              'Durability',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...weapon!.durability!.asMap().entries.map((entry) {
              final durabilityData = entry.value as Map<String, dynamic>;
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sharpness Level ${entry.key + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 16,
                        children: [
                          if (durabilityData['red'] != null)
                            _buildDurabilityItem('Red', durabilityData['red'], Colors.red),
                          if (durabilityData['orange'] != null)
                            _buildDurabilityItem('Orange', durabilityData['orange'], Colors.orange),
                          if (durabilityData['yellow'] != null)
                            _buildDurabilityItem('Yellow', durabilityData['yellow'], Colors.yellow),
                          if (durabilityData['green'] != null)
                            _buildDurabilityItem('Green', durabilityData['green'], Colors.green),
                          if (durabilityData['blue'] != null)
                            _buildDurabilityItem('Blue', durabilityData['blue'], Colors.blue),
                          if (durabilityData['white'] != null)
                            _buildDurabilityItem('White', durabilityData['white'], Colors.white),
                          if (durabilityData['purple'] != null)
                            _buildDurabilityItem('Purple', durabilityData['purple'], Colors.purple),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
          // Mostra l'elderseal
          if (weapon!.elderseal != null) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Elderseal',
              weapon!.elderseal!,
              Icons.star,
            ),
          ],
          // Mostra il crafting
          if (weapon!.crafting != null) ...[
            const SizedBox(height: 24),
            Text(
              'Crafting',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildCraftingInfo(weapon!.crafting!),
          ],
        ],
      ),
    );
  }

  Widget _buildDurabilityItem(String label, dynamic value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text('$label: $value'),
      ],
    );
  }

  Widget _buildCraftingInfo(Map<String, dynamic> crafting) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (crafting['craftable'] != null)
              _buildInfoCard(
                'Craftable',
                crafting['craftable'] == true ? 'Yes' : 'No',
                Icons.build,
              ),
            if (crafting['previous'] != null) ...[
              const SizedBox(height: 16),
              _buildInfoCard(
                'Previous Weapon ID',
                crafting['previous'].toString(),
                Icons.arrow_back,
              ),
            ],
            if (crafting['branches'] != null && (crafting['branches'] as List).isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Branches',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: (crafting['branches'] as List).map((branch) {
                  return Chip(
                    label: Text('ID: $branch'),
                  );
                }).toList(),
              ),
            ],
            if (crafting['upgradeMaterials'] != null && (crafting['upgradeMaterials'] as List).isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Upgrade Materials',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              ...(crafting['upgradeMaterials'] as List).map((material) {
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
            if (crafting['craftingMaterials'] != null && (crafting['craftingMaterials'] as List).isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Crafting Materials',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              ...(crafting['craftingMaterials'] as List).map((material) {
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

  Widget _buildWeaponImage() {
    // Se c'è un'immagine grande, usala (ridotta per evitare pixelation)
    if (weapon!.imageUrl != null) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: OptimizedImage(
            imageUrl: weapon!.imageUrl,
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
        ),
      );
    }
    
    // Se c'è solo un'icona, usala (ridotta per evitare pixelation)
    if (weapon!.iconUrl != null) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: OptimizedImage(
            imageUrl: weapon!.iconUrl,
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
      child: const Icon(
        Icons.sports_martial_arts,
        size: 100,
        color: Colors.grey,
      ),
    );
  }
}

