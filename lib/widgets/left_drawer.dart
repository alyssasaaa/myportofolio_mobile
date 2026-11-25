import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/menu.dart';

import '../screens/experience_list.dart';
import '../widgets/auth_guard.dart';
import '../services/auth_state.dart';

import 'package:provider/provider.dart';

import 'package:myportofolio_mobile/screens/competition_form.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedIn = context.watch<AuthState>().isLoggedIn;
    final scaffold = Scaffold.of(context);
    return Drawer(
      child: ListView(
        children: [
          Container(
            color: Colors.indigo,
            constraints: const BoxConstraints(minHeight: 160),
            padding: const EdgeInsets.all(16),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Portfolio',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Explore personal competitions and experiences!',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            // Navigate to the portfolio home screen
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.work_outline),
            title: const Text('View Experiences'),
            onTap: () {
              scaffold.closeDrawer();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExperienceListPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text('Add Experiences'),
            onTap: () {
              scaffold.closeDrawer();
              openExperienceForm(scaffold.context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.emoji_events_outlined),
            title: const Text('Add Competitions'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const CompetitionFormPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(loggedIn ? Icons.logout : Icons.login),
            title: Text(loggedIn ? 'Logout' : 'Login'),
            onTap: () {
              scaffold.closeDrawer();
              if (loggedIn) {
                logout(scaffold.context);
              } else {
                ensureLoggedIn(scaffold.context);
              }
            },
          ),
        ],
      ),
    );
  }
}
