import 'dart:io';

import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isDesktop = false;
  @override
  void initState() {
    super.initState();
    if (Platform.isLinux) {
      isDesktop = true;
    } else {
      isDesktop = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: isDesktop ? buildDesktopLayout() : buildMobileLayout(),
    );
  }

  Widget buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: buildProfileCard(),),
              const SizedBox(width: 16),
              Expanded(child: buildSettingsCard(),),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: buildUsageStatsCard(),),
              const SizedBox(width: 16),
              Expanded(child: buildCurrentLocationCard(),),
            ],
          ),
        ],
      ),
      // child: GridView.count(
      //   crossAxisCount: 2,
      //   mainAxisSpacing: 16,
      //   crossAxisSpacing: 16,
      //   childAspectRatio: 1.5,
      //   children: [
      //     buildProfileCard(),
      //     buildSettingsCard(),
      //     buildUsageStatsCard(),
      //     buildCurrentLocationCard(),
      //   ],
      // ),
    );
  }

  Widget buildMobileLayout() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        buildProfileCard(),
        const SizedBox(height: 16),
        buildSettingsCard(),
        const SizedBox(height: 16),
        buildUsageStatsCard(),
        const SizedBox(height: 16),
        buildCurrentLocationCard(),
      ],
    );
  }

  Widget buildProfileCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blueAccent, // Or any color you prefer
              child: Text(
                // name.isNotEmpty ? name[0].toUpperCase() : '',
                "SG".toUpperCase(),
                style: const TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),

            const SizedBox(height: 8),
            const Text(
              'Soumyadip Guria',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'soumyadip.wesee@gmail.com',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () {}, child: const Text('Edit Profile')),
          ],
        ),
      ),
    );
  }

  Widget buildSettingsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () {},
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.notifications),
              title: const Text('Notification Preferences'),
              onTap: () {},
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.palette),
              title: const Text('Theme'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUsageStatsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'App Usage Stats',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.access_time),
              title: const Text('Total Time Spent'),
              subtitle: const Text('12 hours 45 minutes'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.video_call),
              title: const Text('Meetings Joined'),
              subtitle: const Text('34 meetings'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Meetings Hosted'),
              subtitle: const Text('5 meetings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCurrentLocationCard() {
    const String currentLocation = 'RK Puram, WESEE, INDIA';

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Icon(Icons.location_on, color: Colors.red),
                SizedBox(width: 8),
                Text(currentLocation, style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Here you'd trigger a location update.
              },
              child: const Text('Refresh Location'),
            ),
          ],
        ),
      ),
    );
  }
}
