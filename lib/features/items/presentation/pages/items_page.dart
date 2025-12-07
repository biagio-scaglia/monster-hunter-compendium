import 'package:flutter/material.dart';
import '../../../../shared/widgets/gradient_card.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/search_and_filter_bar.dart';
import '../../../../shared/widgets/filter_chip_bar.dart';
import '../../../../shared/theme/app_theme.dart';
import '../providers/items_provider.dart';
import 'item_detail_page.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  late ItemsProvider provider;
  List<FilterChipData> _rarityFilters = [];

  @override
  void initState() {
    super.initState();
    provider = ItemsProvider();
    provider.loadItems().then((_) {
      _initializeFilters();
    });
  }

  void _initializeFilters() {
    final rarities = provider.getAvailableRarities();
    
    setState(() {
      _rarityFilters = rarities.map((rarity) => FilterChipData(
        label: '⭐ Rarity $rarity',
        value: rarity.toString(),
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
        title: const Text('Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              provider.refreshItems().then((_) {
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
          if (provider.isLoading && provider.allItems.isEmpty) {
            return const ShimmerList(itemCount: 8);
          }

          if (provider.hasError && provider.allItems.isEmpty) {
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
                      'Error loading items',
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
                        provider.refreshItems().then((_) {
                          _initializeFilters();
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          final items = provider.items;
          final hasResults = items.isNotEmpty;
          final hasFilters = provider.searchQuery.isNotEmpty ||
              provider.selectedRarities.isNotEmpty;

          return Column(
            children: [
              SearchAndFilterBar(
                searchHint: 'Search items...',
                onSearchChanged: (query) {
                  provider.setSearchQuery(query);
                },
                filters: [],
                selectedFilters: [],
                onFiltersChanged: (_) {},
                showFilters: false,
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
                        onRefresh: () => provider.refreshItems(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return GradientCard(
                              margin: const EdgeInsets.only(bottom: 12),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemDetailPage(
                                      itemId: item.id,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey[300],
                                    ),
                                    child: const Icon(Icons.inventory_2, size: 40),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: AppTheme.cardTitleStyle,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.description,
                                          style: AppTheme.cardBodyStyle,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Rarity: ${item.rarity}',
                                          style: AppTheme.cardBodyStyle,
                                        ),
                                        if (item.value > 0)
                                          Text(
                                            'Value: ${item.value}',
                                            style: AppTheme.cardBodyStyle,
                                          ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios),
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
                              hasFilters ? Icons.filter_alt_off : Icons.inventory_2,
                              size: 64,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              hasFilters
                                  ? 'No items match your filters'
                                  : 'No items found',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            if (hasFilters) ...[
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  provider.setSearchQuery('');
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
