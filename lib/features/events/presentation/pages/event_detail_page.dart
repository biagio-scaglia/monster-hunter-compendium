import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/models/event_model.dart';

class EventDetailPage extends StatefulWidget {
  final int eventId;

  const EventDetailPage({
    super.key,
    required this.eventId,
  });

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final EventRepository repository = EventRepository();
  EventModel? event;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadEvent();
  }

  Future<void> loadEvent() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final loadedEvent = await repository.getEventById(widget.eventId);
      setState(() {
        event = loadedEvent;
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
        title: const Text('Event Details'),
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
              'Error Loading Event',
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
              onPressed: loadEvent,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (event == null) {
      return const Center(
        child: Text('Event not found'),
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
              Icons.event,
              size: 100,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            event!.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange[700],
                ),
          ),
          const SizedBox(height: 24),
          _buildInfoCard(
            'Event ID',
            event!.id.toString(),
            Icons.tag,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Type',
            event!.type,
            Icons.category,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Platform',
            event!.platform,
            Icons.computer,
          ),
          const SizedBox(height: 16),
          _buildInfoCard(
            'Expansion',
            event!.expansion,
            Icons.expand,
          ),
          if (event!.exclusive != null) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Exclusive',
              event!.exclusive!,
              Icons.star,
            ),
          ],
          if (event!.description != null && event!.description!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Description',
              event!.description!,
              Icons.description,
            ),
          ],
          if (event!.requirements != null && event!.requirements!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Requirements',
              event!.requirements!,
              Icons.checklist,
            ),
          ],
          if (event!.questRank != null) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Quest Rank',
              event!.questRank.toString(),
              Icons.star_border,
            ),
          ],
          if (event!.successConditions != null && event!.successConditions!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Success Conditions',
              event!.successConditions!,
              Icons.check_circle,
            ),
          ],
          if (event!.startTimestamp != null) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'Start Date',
              event!.startTimestamp!,
              Icons.calendar_today,
            ),
          ],
          if (event!.endTimestamp != null) ...[
            const SizedBox(height: 16),
            _buildInfoCard(
              'End Date',
              event!.endTimestamp!,
              Icons.event_busy,
            ),
          ],
          // Mostra la location completa se disponibile
          if (event!.location != null) ...[
            const SizedBox(height: 24),
            Text(
              'Location',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.map, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          event!.location!['name']?.toString() ?? 'Unknown',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    if (event!.location!['zoneCount'] != null) ...[
                      const SizedBox(height: 8),
                      Text('Zones: ${event!.location!['zoneCount']}'),
                    ],
                    if (event!.location!['camps'] != null && (event!.location!['camps'] as List).isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text(
                        'Camps',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      ...(event!.location!['camps'] as List).map((camp) {
                        final campData = camp as Map<String, dynamic>;
                        return Card(
                          elevation: 1,
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: const Icon(Icons.place),
                            title: Text(campData['name']?.toString() ?? 'Unknown Camp'),
                            subtitle: Text('Zone: ${campData['zone'] ?? 'Unknown'}'),
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
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

