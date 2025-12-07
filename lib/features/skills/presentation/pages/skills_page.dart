import 'package:flutter/material.dart';
import '../../../../shared/widgets/gradient_card.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/widgets/search_and_filter_bar.dart';
import '../../../../shared/theme/app_theme.dart';
import '../providers/skills_provider.dart';
import 'skill_detail_page.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  late SkillsProvider provider;

  @override
  void initState() {
    super.initState();
    provider = SkillsProvider();
    provider.loadSkills();
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
        title: const Text('Skills'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              provider.refreshSkills();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: provider,
        builder: (context, _) {
          if (provider.isLoading && provider.allSkills.isEmpty) {
            return const ShimmerList(itemCount: 8);
          }

          if (provider.hasError && provider.allSkills.isEmpty) {
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
                      'Error loading skills',
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
                        provider.refreshSkills();
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          final skills = provider.skills;
          final hasResults = skills.isNotEmpty;
          final hasFilters = provider.searchQuery.isNotEmpty;

          return Column(
            children: [
              SearchAndFilterBar(
                searchHint: 'Search skills...',
                onSearchChanged: (query) {
                  provider.setSearchQuery(query);
                },
                filters: [],
                selectedFilters: [],
                onFiltersChanged: (_) {},
                showFilters: false,
              ),
              Expanded(
                child: hasResults
                    ? RefreshIndicator(
                        onRefresh: () => provider.refreshSkills(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: skills.length,
                          itemBuilder: (context, index) {
                            final skill = skills[index];
                            return GradientCard(
                              margin: const EdgeInsets.only(bottom: 12),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SkillDetailPage(
                                      skillId: skill.id,
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
                                    child: const Icon(Icons.stars, size: 40),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          skill.name,
                                          style: AppTheme.cardTitleStyle,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          skill.description,
                                          style: AppTheme.cardBodyStyle,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (skill.ranks.isNotEmpty)
                                          Text(
                                            'Ranks: ${skill.ranks.length}',
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
                              hasFilters ? Icons.filter_alt_off : Icons.stars,
                              size: 64,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              hasFilters
                                  ? 'No skills match your filters'
                                  : 'No skills found',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            if (hasFilters) ...[
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: () {
                                  provider.setSearchQuery('');
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
