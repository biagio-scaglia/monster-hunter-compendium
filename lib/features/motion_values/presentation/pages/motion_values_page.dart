import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
import '../../../../shared/widgets/gradient_card.dart';
import '../../../../shared/widgets/search_bar.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../data/models/motion_value_model.dart';
import '../providers/motion_values_provider.dart';

class MotionValuesPage extends StatefulWidget {
  final String? weaponType;
  
  const MotionValuesPage({super.key, this.weaponType});

  @override
  State<MotionValuesPage> createState() => _MotionValuesPageState();
}

class _MotionValuesPageState extends State<MotionValuesPage> {
  late MotionValuesProvider provider;

  @override
  void initState() {
    super.initState();
    provider = MotionValuesProvider();
    provider.loadMotionValues(weaponType: widget.weaponType);
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
        title: Text(widget.weaponType != null ? 'Motion Values - ${widget.weaponType}' : 'Motion Values'),
      ),
      body: ResponsiveContainer(
        child: ListenableBuilder(
          listenable: provider,
          builder: (context, _) {
            if (provider.isLoading && provider.motionValues.isEmpty) {
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
                      onPressed: () => provider.loadMotionValues(weaponType: widget.weaponType),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => provider.refreshMotionValues(weaponType: widget.weaponType),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SearchBarWidget(
                      hintText: 'Search motion values...',
                      onSearchChanged: (query) {
                        // Implementa ricerca se necessario
                      },
                    ),
                  ),
                  Expanded(
                    child: provider.motionValues.isEmpty
                        ? const Center(child: Text('No motion values found'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: provider.motionValues.length,
                            itemBuilder: (context, index) {
                              final motionValue = provider.motionValues[index];
                              return GradientCard(
                                child: ListTile(
                                  leading: const Icon(Icons.sports_martial_arts),
                                  title: Text(motionValue.name),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Weapon: ${motionValue.weaponType}'),
                                      Text('Damage Type: ${motionValue.damageType}'),
                                      if (motionValue.hits.isNotEmpty)
                                        Text('Hits: ${motionValue.hits.join(", ")}'),
                                    ],
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

