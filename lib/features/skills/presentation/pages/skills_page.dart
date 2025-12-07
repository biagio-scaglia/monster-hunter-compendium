import 'package:flutter/material.dart';
import '../../../../shared/widgets/responsive_container.dart';
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
          ),
        ],
      ),
      body: ResponsiveContainer(
        child: ListenableBuilder(
          listenable: provider,
          builder: (context, _) {
            if (provider.isLoading && provider.skills.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (provider.hasError && provider.skills.isEmpty) {
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
                      'Error loading skills',
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
                        provider.refreshSkills();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (provider.skills.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.stars,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text('No skills found'),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => provider.refreshSkills(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.skills.length,
                itemBuilder: (context, index) {
                  final skill = provider.skills[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.stars, size: 40),
                      title: Text(
                        skill.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(skill.description),
                          if (skill.ranks.isNotEmpty)
                            Text('Ranks: ${skill.ranks.length}'),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
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

