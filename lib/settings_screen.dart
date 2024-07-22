import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'preference_screen.dart';
import 'book_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            value: bookProvider.isDarkMode,
            onChanged: (value) {
              bookProvider.toggleDarkMode();
            },
          ),
          ListTile(
            title: Text('Preferences'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PreferenceScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
