import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/experience_card.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String npm = "2506558466";
  final String nama = "Alyssa Rahma Adjani";
  final String kelas = "PBP KI";

  final List<ItemHomepage> items = [
    ItemHomepage(
      "View Experiences",
      Icons.emoji_people_rounded,
      Colors.red.shade400,
    ),
    ItemHomepage(
      "View Competitions",
      Icons.computer_rounded,
      Colors.orange.shade600,
    ),
    ItemHomepage("View Education", Icons.school, Colors.yellow.shade700),
    ItemHomepage(
      "Add Experiences",
      Icons.add_circle,
      Colors.lightGreen.shade400,
    ),
    ItemHomepage("Add Competitions", Icons.add_circle, Colors.blue.shade400),
    ItemHomepage("Logout", Icons.logout, Colors.deepPurpleAccent.shade200),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MyPortfolio',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const LeftDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: InfoCard(title: 'NPM', content: npm),
              ),
              Expanded(
                child: InfoCard(title: 'Name', content: nama),
              ),
              Expanded(
                child: InfoCard(title: 'Class', content: kelas),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 32, bottom: 20),
            child: Text(
              'Welcome to MyPortfolio Mobile!',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              const spacing = 10.0;
              final columns = constraints.maxWidth >= 380 ? 3 : 2;
              final width =
                  (constraints.maxWidth - spacing * (columns - 1)) / columns;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  for (final item in items)
                    SizedBox(
                      width: width,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 104),
                        child: ItemCard(item),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  // Information card displaying a title and its associated content.
  final String title;
  final String content;

  const InfoCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 16),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(content, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class ItemHomepage {
  final String name;
  final IconData icon;
  final Color color;

  ItemHomepage(this.name, this.icon, this.color);
}
