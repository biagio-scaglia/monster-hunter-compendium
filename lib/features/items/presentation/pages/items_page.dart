import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
import '../providers/items_provider.dart';
import 'item_detail_page.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  late ItemsProvider provider;

  @override
  void initState() {
    super.initState();
    provider = ItemsProvider();
    provider.loadItems();
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
              provider.refreshItems();
            },
          ),
        ],
      ),
      body: ResponsiveContainer(
        child: ListenableBuilder(
          listenable: provider,
          builder: (context, _) {
            if (provider.isLoading && provider.items.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (provider.hasError && provider.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
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
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        provider.refreshItems();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (provider.items.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text('No items found'),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => provider.refreshItems(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.items.length,
                itemBuilder: (context, index) {
                  final item = provider.items[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.inventory_2, size: 40),
                      title: Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.description),
                          Text('Rarity: ${item.rarity}'),
                          if (item.value > 0) Text('Value: ${item.value}'),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
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
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

