import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../shared/widgets/gradient_card.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../../../shared/widgets/fade_in_image_widget.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/search_and_filter_bar.dart';
import '../../../../shared/widgets/filter_chip_bar.dart';
import '../../../../shared/theme/app_theme.dart';
import '../providers/armor_provider.dart';
import 'armor_detail_page.dart';

class ArmorPage extends StatefulWidget {
  const ArmorPage({super.key});

  @override
  State<ArmorPage> createState() => _ArmorPageState();
}

class _ArmorPageState extends State<ArmorPage> {
  late ArmorProvider provider;
  late ScrollController _scrollController;
  List<FilterChipData> _typeFilters = [];
  List<FilterChipData> _rankFilters = [];
  List<FilterChipData> _rarityFilters = [];

  @override
  void initState() {
    super.initState();
    provider = ArmorProvider();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    provider.loadArmor(limit: 50).then((_) {
      _initializeFilters();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      provider.loadMoreArmor();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    provider.dispose();
    super.dispose();
  }

  String _getArmorTypeEmoji(String type) {
    final lowerType = type.toLowerCase();
    if (lowerType.contains('head')) return '👑';
    if (lowerType.contains('chest')) return '👕';
    if (lowerType.contains('arm') || lowerType.contains('glove')) return '💪';
    if (lowerType.contains('waist')) return '🩲';
    if (lowerType.contains('leg')) return '👖';
    return '🛡️';
  }

  String _getRankEmoji(String rank) {
    final lowerRank = rank.toLowerCase();
    if (lowerRank.contains('low')) return '🥉';
    if (lowerRank.contains('high')) return '🥈';
    if (lowerRank.contains('master')) return '🥇';
    return '🛡️';
  }

  void _initializeFilters() {
    final types = provider.getAvailableTypes();
    final ranks = provider.getAvailableRanks();
    final rarities = provider.getAvailableRarities();
    
    setState(() {
      _typeFilters = types.map((type) => FilterChipData(
        label: '${_getArmorTypeEmoji(type)} $type',
        value: type,
      )).toList();
      
      _rankFilters = ranks.map((rank) => FilterChipData(
        label: '${_getRankEmoji(rank)} $rank',
        value: rank,
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
        title: const Text('Armor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              provider.refreshArmor().then((_) {
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
          if (provider.isLoading && provider.allArmor.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Loading...',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            );
          }

          if (provider.hasError && provider.allArmor.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppTheme.errorColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading armor',
                      style: Theme.of(context).textTheme.titleLarge,
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
                        provider.refreshArmor().then((_) {
                          _initializeFilters();
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          final armor = provider.armor;
          final hasResults = armor.isNotEmpty;
          final hasFilters = provider.searchQuery.isNotEmpty ||
              provider.selectedTypes.isNotEmpty ||
              provider.selectedRanks.isNotEmpty ||
              provider.selectedRarities.isNotEmpty;

          return Column(
            children: [
              SearchAndFilterBar(
                searchHint: 'Search armor...',
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
              if (_rankFilters.isNotEmpty)
                FilterChipBar(
                  filters: _rankFilters,
                  selectedFilters: provider.selectedRanks,
                  onFiltersChanged: (filters) {
                    provider.setSelectedRanks(filters);
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
                        onRefresh: () => provider.refreshArmor(),
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          cacheExtent: 500,
                          itemCount: armor.length + (provider.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == armor.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final armorItem = armor[index];
                            return GradientCard(
                              margin: const EdgeInsets.only(bottom: 12),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ArmorDetailPage(
                                      armorId: armorItem.id,
                                    ),
                                  ),
                                );
                              },
                              child: Builder(
                                builder: (context) {
                                  if (armorItem.imageUrl != null) {
                                    return Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: FadeInImageWidget(
                                            imageUrl: armorItem.imageUrl!,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                            placeholder: Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey[300],
                                              child: const Center(
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                              ),
                                            ),
                                            errorWidget: Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.error_outline, color: Colors.red, size: 30),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                armorItem.name,
                                                style: AppTheme.cardTitleStyle,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Type: ${armorItem.type}',
                                                style: AppTheme.cardBodyStyle,
                                              ),
                                              Text(
                                                'Rank: ${armorItem.rank}',
                                                style: AppTheme.cardBodyStyle,
                                              ),
                                              Text(
                                                'Rarity: ${armorItem.rarity}',
                                                style: AppTheme.cardBodyStyle,
                                              ),
                                              if (armorItem.defense != null && armorItem.defense!['base'] != null)
                                                Text(
                                                  'Defense: ${armorItem.defense!['base']}',
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
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: Colors.grey[300],
                                          ),
                                          child: const Icon(Icons.shield, size: 40),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                armorItem.name,
                                                style: AppTheme.cardTitleStyle,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Type: ${armorItem.type}',
                                                style: AppTheme.cardBodyStyle,
                                              ),
                                              Text(
                                                'Rank: ${armorItem.rank}',
                                                style: AppTheme.cardBodyStyle,
                                              ),
                                              Text(
                                                'Rarity: ${armorItem.rarity}',
                                                style: AppTheme.cardBodyStyle,
                                              ),
                                              if (armorItem.defense != null && armorItem.defense!['base'] != null)
                                                Text(
                                                  'Defense: ${armorItem.defense!['base']}',
                                                  style: AppTheme.cardBodyStyle,
                                                ),
                                            ],
                                          ),
                                        ),
                                        const Icon(Icons.arrow_forward_ios),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              hasFilters ? Icons.filter_alt_off : Icons.shield,
                              size: 64,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              hasFilters
                                  ? 'No armor match your filters'
                                  : 'No armor found',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            if (hasFilters) ...[
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  provider.setSearchQuery('');
                                  provider.setSelectedTypes([]);
                                  provider.setSelectedRanks([]);
                                  provider.setSelectedRarities([]);
                                },
                                child: const Text('Clear filters'),
                              ),
                            ],
                          ],
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
