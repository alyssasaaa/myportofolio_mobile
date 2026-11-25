import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/experience.dart';
import '../services/api_client.dart';

class ExperienceListPage extends StatefulWidget {
  const ExperienceListPage({super.key});
  @override
  State<ExperienceListPage> createState() => _ExperienceListPageState();
}

class _ExperienceListPageState extends State<ExperienceListPage> {
  late Future<List<Experience>> experiences;

  @override
  void initState() {
    super.initState();
    experiences = context.read<ApiClient>().getExperiences();
  }

  Future<void> reload() async {
    final next = context.read<ApiClient>().getExperiences();
    setState(() => experiences = next);
    try {
      await next;
    } catch (_) {
      // FutureBuilder displays the retry action.
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Experiences')),
    body: FutureBuilder<List<Experience>>(
      future: experiences,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Could not load experiences.'),
                TextButton(onPressed: reload, child: const Text('Retry')),
              ],
            ),
          );
        }
        final items = snapshot.requireData;
        return RefreshIndicator(
          onRefresh: reload,
          child: items.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('No experiences found.')),
                    ),
                  ],
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return ListTile(
                      title: Text(item.title),
                      subtitle: Text(
                        '${item.category} · ${item.description}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExperienceDetailPage(item),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    ),
  );
}

class ExperienceDetailPage extends StatelessWidget {
  const ExperienceDetailPage(this.item, {super.key});
  final Experience item;
  @override
  Widget build(BuildContext context) {
    final dates = MaterialLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (item.thumbnail?.isNotEmpty == true)
            Image.network(
              item.thumbnail!,
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Text('Thumbnail unavailable'),
            ),
          Text(item.description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          Text('Category: ${item.category}'),
          Text('Education stage: ${item.stage}'),
          if (item.startedAt != null)
            Text(
              'Started: ${dates.formatMediumDate(item.startedAt!.toLocal())}',
            ),
          Text(
            item.endedAt == null
                ? 'Ongoing'
                : 'Ended: ${dates.formatMediumDate(item.endedAt!.toLocal())}',
          ),
          Text('Stars: ${item.starCount}'),
          if (item.starredByNames.isNotEmpty)
            Text('Starred by: ${item.starredByNames}'),
        ],
      ),
    );
  }
}
