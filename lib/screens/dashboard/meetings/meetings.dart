import 'dart:io';

import 'package:flutter/material.dart';

class Meetings extends StatefulWidget {
  const Meetings({super.key});

  @override
  State<Meetings> createState() => _MeetingsState();
}

class _MeetingsState extends State<Meetings> {
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
      appBar: AppBar(title: const Text('Meetings')),
      body: isDesktop ? buildDesktopLayout() : buildMobileLayout(),
    );
  }

  // Desktop layout: grid-like
  Widget buildDesktopLayout() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: buildScheduledMeetingsCard()),
              const SizedBox(width: 16),
              Expanded(child: buildPastMeetingsCard()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: buildMeetingPreferencesCard()),
              const SizedBox(width: 16),
              Expanded(child: buildMeetingRemindersCard()),
            ],
          ),
        ],
      ),
    );
  }

  // Mobile layout: vertical list
  Widget buildMobileLayout() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        buildScheduledMeetingsCard(),
        const SizedBox(height: 16),
        buildPastMeetingsCard(),
        const SizedBox(height: 16),
        buildMeetingPreferencesCard(),
        const SizedBox(height: 16),
        buildMeetingRemindersCard(),
      ],
    );
  }

  Widget buildScheduledMeetingsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Scheduled Meetings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: const Text('View All')),
              ],
            ),
            const SizedBox(height: 8),
            buildDummyMeetingTile('Team Sync', 'Tomorrow, 10:00 AM'),
            buildDummyMeetingTile('Client Call', 'Friday, 3:00 PM'),
          ],
        ),
      ),
    );
  }

  Widget buildPastMeetingsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Past Meetings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(onPressed: () {}, child: const Text('View History')),
              ],
            ),
            const SizedBox(height: 8),
            buildDummyMeetingTile('Project Review', 'Yesterday, 2:00 PM'),
            buildDummyMeetingTile('Daily Standup', 'Today, 9:00 AM'),
          ],
        ),
      ),
    );
  }

  Widget buildMeetingPreferencesCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Meeting Preferences',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Edit Preferences'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Default Video: On'),
            const Text('Default Microphone: Off'),
            const Text('Auto-Recording: Disabled'),
          ],
        ),
      ),
    );
  }

  Widget buildMeetingRemindersCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Meeting Reminders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Stay up to date with your upcoming meetings.'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Set Reminders'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDummyMeetingTile(String title, String dateTime) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle: Text(dateTime, style: const TextStyle(color: Colors.grey)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}
