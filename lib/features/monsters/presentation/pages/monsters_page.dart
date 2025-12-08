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
  late ScrollController _scrollController;
  List<FilterChipData> _typeFilters = [];
  List<FilterChipData> _speciesFilters = [];

  @override
  void initState() {
    super.initState();
    provider = MonstersProvider();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    provider.loadMonsters(limit: 50).then((_) {
      _initializeFilters();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.8) {
      provider.loadMoreMonsters();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    provider.dispose();
    super.dispose();
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
                      'Error loading monsters',
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
                        color: AppTheme.primaryColor,
                        child: GridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          cacheExtent: 500,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: monsters.length + (provider.isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == monsters.length) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
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
                                  const SizedBox(height: 10),
                                  Text(
                                    monster.name,
                                    style: AppTheme.cardTitleStyle.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (monster.type.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      monster.type,
                                      style: AppTheme.cardSubtitleStyle.copyWith(
                                        fontSize: 12,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade700,
                                      ),
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
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                hasFilters ? Icons.filter_alt_off : Icons.pets,
                                size: 80,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.shade600
                                    : Colors.grey.shade400,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                hasFilters
                                    ? 'No monsters match your filters'
                                    : 'No monsters found',
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
                                    provider.setSelectedSpecies([]);
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
