import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Profile Section
          _buildProfileSection(context),

          const SizedBox(height: 20), // Space between sections

          // Subscription Section
          _buildSubscriptionSection(),

          const SizedBox(height: 20), // Space between sections

          // Settings Section
          _buildSettingsSection(context),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('Name: Jeethan'),
            ),
            ListTile(
              title: Text('Email: xyz@gmail.com'),
            ),
            ListTile(
              title: Text('Age: 18'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Subscription',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('Subscription Type: Free Plan'),
              subtitle: const Text('Upgrade to Premium for more features.'),
              trailing: ElevatedButton(
                onPressed: () {
                  // Add functionality for upgrading
                },
                child: const Text('Upgrade'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Theme Setting
            ListTile(
              title: const Text('Theme Setting'),
              onTap: () {
                _showThemeDialog(context);
              },
            ),

            // Language Setting
            ListTile(
              title: const Text('Language Setting'),
              onTap: () {
                _showLanguageDialog(context);
              },
            ),

            // App Version
            const ListTile(
              title: Text('App Version'),
              subtitle: Text('1.0.0'),
            ),

            // Contact Developer
            ListTile(
              title: const Text('Contact Developer'),
              onTap: () {
                // Add functionality to contact developer
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Light'),
                onTap: () {
                  AdaptiveTheme.of(context).setLight();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Dark'),
                onTap: () {
                  AdaptiveTheme.of(context).setDark();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('System Default'),
                onTap: () {
                  AdaptiveTheme.of(context).setSystem();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Language Dialog
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  Navigator.pop(context);
                  // Add functionality to set English
                },
              ),
              ListTile(
                title: const Text('Hindi'),
                onTap: () {
                  Navigator.pop(context);
                  // Add functionality to set Hindi
                },
              ),
              ListTile(
                title: const Text('Kannada'),
                onTap: () {
                  Navigator.pop(context);
                  // Add functionality to set Kannada
                },
              ),
              // Add more languages here
            ],
          ),
        );
      },
    );
  }
}
