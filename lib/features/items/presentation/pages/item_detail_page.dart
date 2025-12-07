import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
import '../../data/repositories/item_repository.dart';
import '../../data/models/item_model.dart';

class ItemDetailPage extends StatefulWidget {
  final int itemId;

  const ItemDetailPage({
    super.key,
    required this.itemId,
  });

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  final ItemRepository repository = ItemRepository();
  ItemModel? item;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadItem();
  }

  Future<void> loadItem() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final loadedItem = await repository.getItemById(widget.itemId);
      setState(() {
        item = loadedItem;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: ResponsiveContainer(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
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
              'Error Loading Item',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                error ?? 'Unknown error occurred',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: loadItem,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (item == null) {
      return const Center(
        child: Text('Item not found'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.inventory_2,
              size: 100,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            item!.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange[700],
                ),
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            'Item ID',
            item!.id.toString(),
            Icons.tag,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Description',
            item!.description,
            Icons.description,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Rarity',
            item!.rarity.toString(),
            Icons.star,
          ),
          if (item!.carryLimit > 0) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Carry Limit',
              item!.carryLimit.toString(),
              Icons.inventory,
            ),
          ],
          if (item!.value > 0) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Value',
              '${item!.value} Zenny',
              Icons.attach_money,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.deepOrange[700]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

