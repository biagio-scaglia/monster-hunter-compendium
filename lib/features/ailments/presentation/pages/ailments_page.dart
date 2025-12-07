import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
import '../../../../shared/widgets/gradient_card.dart';
import '../../../../shared/widgets/search_bar.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${provider.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.loadAilments(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => provider.refreshAilments(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SearchBarWidget(
                      hintText: 'Search ailments...',
                      onSearchChanged: (query) {
                        provider.loadAilments(query: query.isEmpty ? null : query);
                      },
                    ),
                  ),
                  Expanded(
                    child: provider.ailments.isEmpty
                        ? const Center(child: Text('No ailments found'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: provider.ailments.length,
                            itemBuilder: (context, index) {
                              final ailment = provider.ailments[index];
                              return GradientCard(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AilmentDetailPage(ailmentId: ailment.id),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  leading: Icon(
                                    AilmentHelper.getAilmentIcon(ailment.name),
                                    color: AilmentHelper.getAilmentColor(ailment.name),
                                  ),
                                  title: Text(ailment.name),
                                  subtitle: Text(
                                    ailment.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: const Icon(Icons.arrow_forward_ios),
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

