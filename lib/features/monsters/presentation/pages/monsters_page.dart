import 'package:flutter/material.dart';
import '../../../../shared/widgets/gradient_card.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../../../shared/widgets/fade_in_image_widget.dart';
import '../../../../shared/widgets/rare_badge.dart';
import '../../../../shared/widgets/gradient_button.dart';
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

  @override
  void initState() {
    super.initState();
    provider = MonstersProvider();
    provider.loadMonsters();
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
              provider.refreshMonsters();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: provider,
        builder: (context, _) {
          if (provider.isLoading && provider.monsters.isEmpty) {
            return const ShimmerList(itemCount: 8);
          }

          if (provider.hasError && provider.monsters.isEmpty) {
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
                        provider.refreshMonsters();
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.monsters.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pets,
                    size: 64,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No monsters found',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshMonsters(),
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: provider.monsters.length,
              itemBuilder: (context, index) {
                final monster = provider.monsters[index];
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
                          child: Center(
                            child: Icon(
                              Icons.pets,
                              size: 48,
                              color: Theme.of(context).iconTheme.color,
                            ),
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
          );
        },
      ),
    );
  }
}
