import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../shared/widgets/gradient_card.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../../../shared/widgets/fade_in_image_widget.dart';
import '../../../../shared/widgets/rare_badge.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/search_and_filter_bar.dart';
import '../../../../shared/widgets/filter_chip_bar.dart';
import '../../../../shared/theme/app_theme.dart';
import '../providers/monsters_provider.dart';
import 'monster_detail_page.dart';

class MonstersPage extends StatefulWidget {
  const MonstersPage({super.key});

  @override
  State<MonstersPage> createState() => _MonstersPageState();
}

class _MonstersPageState extends State<MonstersPage> {
  late MonstersProvider provider;
  List<FilterChipData> _typeFilters = [];
  List<FilterChipData> _speciesFilters = [];

  @override
  void initState() {
    super.initState();
    provider = MonstersProvider();
    provider.loadMonsters().then((_) {
      _initializeFilters();
    });
  }

  String _getTypeEmoji(String type) {
    final lowerType = type.toLowerCase();
    if (lowerType.contains('elder')) return '🐉';
    if (lowerType.contains('flying')) return '🦅';
    if (lowerType.contains('brute')) return '🦖';
    if (lowerType.contains('fanged')) return '🐺';
    if (lowerType.contains('bird')) return '🐦';
    if (lowerType.contains('piscine')) return '🐟';
    if (lowerType.contains('carapaceon')) return '🦀';
    if (lowerType.contains('temper')) return '⚡';
    return '🦎';
  }

  String _getSpeciesEmoji(String species) {
    final lowerSpecies = species.toLowerCase();
    if (lowerSpecies.contains('wyvern')) return '🦎';
    if (lowerSpecies.contains('dragon')) return '🐉';
    if (lowerSpecies.contains('beast')) return '🐺';
    if (lowerSpecies.contains('bird')) return '🐦';
    if (lowerSpecies.contains('fish')) return '🐟';
    if (lowerSpecies.contains('insect')) return '🦗';
    return '🐾';
  }

  void _initializeFilters() {
    final types = provider.getAvailableTypes();
    final species = provider.getAvailableSpecies();
    
    setState(() {
      _typeFilters = types.map((type) => FilterChipData(
        label: '${_getTypeEmoji(type)} $type',
        value: type,
      )).toList();
      
      _speciesFilters = species.map((spec) => FilterChipData(
        label: '${_getSpeciesEmoji(spec)} $spec',
        value: spec,
      )).toList();
    });
  }

  @override
  void dispose() {
    provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monsters'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              provider.refreshMonsters().then((_) {
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
          if (provider.isLoading && provider.allMonsters.isEmpty) {
            return const ShimmerList(itemCount: 8);
          }

          if (provider.hasError && provider.allMonsters.isEmpty) {
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
                      'Error loading monsters',
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
                        provider.refreshMonsters().then((_) {
                          _initializeFilters();
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          final monsters = provider.monsters;
          final hasResults = monsters.isNotEmpty;
          final hasFilters = provider.searchQuery.isNotEmpty ||
              provider.selectedTypes.isNotEmpty ||
              provider.selectedSpecies.isNotEmpty;

          return Column(
            children: [
              SearchAndFilterBar(
                searchHint: 'Search monsters...',
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
              if (_speciesFilters.isNotEmpty)
                FilterChipBar(
                  filters: _speciesFilters,
                  selectedFilters: provider.selectedSpecies,
                  onFiltersChanged: (filters) {
                    provider.setSelectedSpecies(filters);
                  },
                ),
              Expanded(
                child: hasResults
                    ? RefreshIndicator(
                        onRefresh: () => provider.refreshMonsters(),
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: monsters.length,
                          itemBuilder: (context, index) {
                            final monster = monsters[index];
                            final isRare = monster.type.toLowerCase().contains('elder') ||
                                monster.type.toLowerCase().contains('rare');

                            return GradientCard(
                              isRare: isRare,
                              margin: EdgeInsets.zero,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MonsterDetailPage(
                                      monsterId: monster.id,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.grey[800]
                                            : Colors.grey[300],
                                      ),
                                      child: Builder(
                                        builder: (context) {
                                          if (monster.iconUrl != null) {
                                            if (kDebugMode) {
                                              print('🐉 [MonstersPage] Rendering immagine per: ${monster.name}');
                                              print('🐉 [MonstersPage] URL: ${monster.iconUrl}');
                                            }
                                            return ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: FadeInImageWidget(
                                                imageUrl: monster.iconUrl!,
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                                placeholder: Center(
                                                  child: Icon(
                                                    Icons.pets,
                                                    size: 48,
                                                    color: Theme.of(context).iconTheme.color,
                                                  ),
                                                ),
                                                errorWidget: Center(
                                                  child: Icon(
                                                    Icons.pets,
                                                    size: 48,
                                                    color: Theme.of(context).iconTheme.color,
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            if (kDebugMode) {
                                              print('⚠️ [MonstersPage] Nessun iconUrl per: ${monster.name}');
                                            }
                                            return Center(
                                              child: Icon(
                                                Icons.pets,
                                                size: 48,
                                                color: Theme.of(context).iconTheme.color,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    monster.name,
                                    style: AppTheme.cardTitleStyle.copyWith(fontSize: 16),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (monster.type.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      monster.type,
                                      style: AppTheme.cardBodyStyle.copyWith(fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                  if (isRare) ...[
                                    const SizedBox(height: 8),
                                    const RareBadge(text: 'RARE'),
                                  ],
                                ],
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
                              hasFilters ? Icons.filter_alt_off : Icons.pets,
                              size: 64,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              hasFilters
                                  ? 'No monsters match your filters'
                                  : 'No monsters found',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            if (hasFilters) ...[
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  provider.setSearchQuery('');
                                  provider.setSelectedTypes([]);
                                  provider.setSelectedSpecies([]);
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
