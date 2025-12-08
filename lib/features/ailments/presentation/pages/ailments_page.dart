import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
import '../../../../shared/widgets/gradient_card.dart';
import '../../../../shared/widgets/search_bar.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../../../shared/widgets/gradient_button.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/utils/ailment_helper.dart';
import '../../data/models/ailment_model.dart';
import '../providers/ailments_provider.dart';
import 'ailment_detail_page.dart';

class AilmentsPage extends StatefulWidget {
  const AilmentsPage({super.key});

  @override
  State<AilmentsPage> createState() => _AilmentsPageState();
}

class _AilmentsPageState extends State<AilmentsPage> {
  late AilmentsProvider provider;

  @override
  void initState() {
    super.initState();
    provider = AilmentsProvider();
    provider.loadAilments();
  }

  @override
  void dispose() {
    provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ailments'),
      ),
      body: ResponsiveContainer(
        child: ListenableBuilder(
          listenable: provider,
          builder: (context, _) {
            if (provider.isLoading && provider.ailments.isEmpty) {
              return const ShimmerList(itemCount: 10);
            }

            if (provider.hasError) {
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
                        'Error loading ailments',
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
                        onPressed: () => provider.loadAilments(),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => provider.refreshAilments(),
              color: AppTheme.primaryColor,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  SearchBarWidget(
                    hintText: 'Search ailments...',
                    onSearchChanged: (query) {
                      provider.loadAilments(query: query.isEmpty ? null : query);
                    },
                  ),
                  Expanded(
                    child: provider.ailments.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.medical_services_outlined,
                                  size: 80,
                                  color: isDark 
                                      ? Colors.grey.shade600 
                                      : Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No ailments found',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: isDark 
                                        ? Colors.grey.shade400 
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 12,
                            ),
                            itemCount: provider.ailments.length,
                            itemBuilder: (context, index) {
                              final ailment = provider.ailments[index];
                              return GradientCard(
                                margin: const EdgeInsets.only(bottom: 10),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AilmentDetailPage(ailmentId: ailment.id),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  leading: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: AilmentHelper.getAilmentColor(ailment.name)
                                          .withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      AilmentHelper.getAilmentIcon(ailment.name),
                                      color: AilmentHelper.getAilmentColor(ailment.name),
                                      size: 24,
                                    ),
                                  ),
                                  title: Text(
                                    ailment.name,
                                    style: AppTheme.cardTitleStyle,
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      ailment.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTheme.cardBodyStyle.copyWith(
                                        color: isDark 
                                            ? Colors.grey.shade400 
                                            : Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: isDark 
                                        ? Colors.grey.shade500 
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

