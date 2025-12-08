import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../shared/widgets/gradient_card.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../../../shared/widgets/fade_in_image_widget.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/search_and_filter_bar.dart';
import '../../../../shared/widgets/filter_chip_bar.dart';
import '../../../../shared/theme/app_theme.dart';
import '../providers/weapons_provider.dart';
import 'weapon_detail_page.dart';

class WeaponsPage extends StatefulWidget {
  const WeaponsPage({super.key});

  @override
  State<WeaponsPage> createState() => _WeaponsPageState();
}

class _WeaponsPageState extends State<WeaponsPage> {
  late WeaponsProvider provider;
  late ScrollController _scrollController;
  List<FilterChipData> _typeFilters = [];
  List<FilterChipData> _rarityFilters = [];

  @override
  void initState() {
    super.initState();
    provider = WeaponsProvider();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    provider.loadWeapons(limit: 50).then((_) {
      _initializeFilters();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      provider.loadMoreWeapons();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    provider.dispose();
    super.dispose();
  }

  String _getWeaponTypeEmoji(String type) {
    final lowerType = type.toLowerCase();
    if (lowerType.contains('great sword') || lowerType.contains('greatsword')) return '⚔️';
    if (lowerType.contains('long sword') || lowerType.contains('longsword')) return '🗡️';
    if (lowerType.contains('sword & shield') || lowerType.contains('sword and shield')) return '🛡️';
    if (lowerType.contains('dual blade')) return '⚔️⚔️';
    if (lowerType.contains('hammer')) return '🔨';
    if (lowerType.contains('hunting horn')) return '🎺';
    if (lowerType.contains('lance')) return '🗡️';
    if (lowerType.contains('gunlance')) return '🔫';
    if (lowerType.contains('switch axe') || lowerType.contains('switchaxe')) return '⚙️';
    if (lowerType.contains('charge blade')) return '⚡';
    if (lowerType.contains('insect glaive')) return '🦗';
    if (lowerType.contains('light bowgun')) return '🏹';
    if (lowerType.contains('heavy bowgun')) return '🎯';
    if (lowerType.contains('bow')) return '🏹';
    return '⚔️';
  }

  void _initializeFilters() {
    final types = provider.getAvailableTypes();
    final rarities = provider.getAvailableRarities();
    
    setState(() {
      _typeFilters = types.map((type) => FilterChipData(
        label: '${_getWeaponTypeEmoji(type)} $type',
        value: type,
      )).toList();
      
      _rarityFilters = rarities.map((rarity) => FilterChipData(
        label: '⭐ Rarity $rarity',
        value: rarity.toString(),
      )).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weapons'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              provider.refreshWeapons().then((_) {
                _initializeFilters();
              });
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: provider,
        builder: (context, _) {
          if (provider.isLoading && provider.allWeapons.isEmpty) {
            return const ShimmerList(itemCount: 8);
          }

          if (provider.hasError && provider.allWeapons.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppTheme.errorColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Error loading weapons',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.error ?? 'Unknown error',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    GradientButton(
                      text: 'Retry',
                      icon: Icons.refresh,
                      onPressed: () {
                        provider.refreshWeapons().then((_) {
                          _initializeFilters();
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          final weapons = provider.weapons;
          final hasResults = weapons.isNotEmpty;
          final hasFilters = provider.searchQuery.isNotEmpty ||
              provider.selectedTypes.isNotEmpty ||
              provider.selectedRarities.isNotEmpty;

          return Column(
            children: [
              SearchAndFilterBar(
                searchHint: 'Search weapons...',
                onSearchChanged: (query) {
                  provider.setSearchQuery(query);
                },
                filters: [],
                selectedFilters: [],
                onFiltersChanged: (_) {},
                showFilters: false,
              ),
              if (_typeFilters.isNotEmpty)
                FilterChipBar(
                  filters: _typeFilters,
                  selectedFilters: provider.selectedTypes,
                  onFiltersChanged: (filters) {
                    provider.setSelectedTypes(filters);
                  },
                ),
              if (_rarityFilters.isNotEmpty)
                FilterChipBar(
                  filters: _rarityFilters,
                  selectedFilters: provider.selectedRarities.map((r) => r.toString()).toList(),
                  onFiltersChanged: (filters) {
                    provider.setSelectedRarities(filters.map((f) => int.tryParse(f) ?? 0).toList());
                  },
                ),
              Expanded(
                child: hasResults
                    ? RefreshIndicator(
                        onRefresh: () => provider.refreshWeapons(),
                        color: AppTheme.primaryColor,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          cacheExtent: 500,
                          itemCount: weapons.length + (provider.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == weapons.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final weapon = weapons[index];
                            return GradientCard(
                              margin: const EdgeInsets.only(bottom: 10),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WeaponDetailPage(
                                      weaponId: weapon.id,
                                    ),
                                  ),
                                );
                              },
                              child: Builder(
                                builder: (context) {
                                  if (weapon.iconUrl != null) {
                                    return Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).brightness == Brightness.dark
                                                  ? Colors.grey.shade800
                                                  : Colors.grey.shade200,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: FadeInImageWidget(
                                              imageUrl: weapon.iconUrl!,
                                              width: 64,
                                              height: 64,
                                              fit: BoxFit.cover,
                                              placeholder: Container(
                                                width: 64,
                                                height: 64,
                                                color: Theme.of(context).brightness == Brightness.dark
                                                    ? Colors.grey.shade800
                                                    : Colors.grey.shade200,
                                                child: const Center(
                                                  child: CircularProgressIndicator(strokeWidth: 2),
                                                ),
                                              ),
                                              errorWidget: Container(
                                                width: 64,
                                                height: 64,
                                                color: Theme.of(context).brightness == Brightness.dark
                                                    ? Colors.grey.shade800
                                                    : Colors.grey.shade200,
                                                child: const Icon(Icons.error_outline, color: Colors.red, size: 30),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                weapon.name,
                                                style: AppTheme.cardTitleStyle,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Type: ${weapon.type}',
                                                style: AppTheme.cardBodyStyle,
                                              ),
                                              Text(
                                                'Rarity: ${weapon.rarity}',
                                                style: AppTheme.cardBodyStyle,
                                              ),
                                              if (weapon.attack != null && weapon.attack!['display'] != null)
                                                Text(
                                                  'Attack: ${weapon.attack!['display']}',
                                                  style: AppTheme.cardBodyStyle,
                                                ),
                                            ],
                                          ),
                                        ),
                                        const Icon(Icons.arrow_forward_ios),
                                      ],
                                    );
                                  } else {
                                    return Row(
                                      children: [
                                        Container(
                                          width: 64,
                                          height: 64,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? Colors.grey.shade800
                                                : Colors.grey.shade200,
                                          ),
                                          child: Icon(
                                            Icons.sports_martial_arts,
                                            size: 36,
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? Colors.grey.shade500
                                                : Colors.grey.shade600,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                weapon.name,
                                                style: AppTheme.cardTitleStyle.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                'Type: ${weapon.type}',
                                                style: AppTheme.cardBodyStyle.copyWith(
                                                  color: Theme.of(context).brightness == Brightness.dark
                                                      ? Colors.grey.shade400
                                                      : Colors.grey.shade700,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Rarity: ${weapon.rarity}',
                                                style: AppTheme.cardBodyStyle.copyWith(
                                                  color: Theme.of(context).brightness == Brightness.dark
                                                      ? Colors.grey.shade400
                                                      : Colors.grey.shade700,
                                                ),
                                              ),
                                              if (weapon.attack != null && weapon.attack!['display'] != null) ...[
                                                const SizedBox(height: 2),
                                                Text(
                                                  'Attack: ${weapon.attack!['display']}',
                                                  style: AppTheme.cardBodyStyle.copyWith(
                                                    color: Theme.of(context).brightness == Brightness.dark
                                                        ? Colors.grey.shade400
                                                        : Colors.grey.shade700,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.grey.shade500
                                              : Colors.grey.shade600,
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      )
                                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                hasFilters ? Icons.filter_alt_off : Icons.sports_martial_arts,
                                size: 80,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade600
                                    : Colors.grey.shade400,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                hasFilters
                                    ? 'No weapons match your filters'
                                    : 'No weapons found',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (hasFilters) ...[
                                const SizedBox(height: 16),
                                GradientButton(
                                  text: 'Clear filters',
                                  icon: Icons.clear_all,
                                  onPressed: () {
                                    provider.setSearchQuery('');
                                    provider.setSelectedTypes([]);
                                    provider.setSelectedRarities([]);
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
