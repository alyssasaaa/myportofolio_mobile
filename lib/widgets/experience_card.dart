import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/menu.dart';

import '../screens/experience_list.dart';
import '../widgets/auth_guard.dart';
import '../services/auth_state.dart';

import 'package:provider/provider.dart';

import 'package:myportofolio_mobile/screens/competition_form.dart';

class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    final loggedIn = context.watch<AuthState>().isLoggedIn;
    final label = item.name == "Logout" && !loggedIn ? "Login" : item.name;
    return Material(
      color: item.color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          if (item.name == "Add Experiences") {
            openExperienceForm(context);
            return;
          }
          if (item.name == "View Experiences") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ExperienceListPage()),
            );
            return;
          }
          if (item.name == "Logout") {
            if (loggedIn) {
              logout(context);
            } else {
              ensureLoggedIn(context);
            }
            return;
          }
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text("You pressed the ${item.name} button!")),
            );
          if (item.name == "Add Competitions") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CompetitionFormPage(),
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  label == "Login" ? Icons.login : item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
