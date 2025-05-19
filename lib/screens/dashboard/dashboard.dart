import 'package:flutter/material.dart';
import 'package:qonnect/screens/dashboard/home/home_page.dart';
import 'package:qonnect/screens/dashboard/meetings/meetings.dart';
import 'package:qonnect/screens/dashboard/messaging/messaging.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    Messaging(),
    Meetings(),
    const Center(child: Text('Account Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'QONNECT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Quantum Optimised Network for Encrypted Communication and Transmission',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => setState(() => _selectedIndex = 0),
            icon: Icon(Icons.home, 
              color: _selectedIndex == 0 ? Colors.blue : Colors.white),
            label: Text('Home', 
              style: TextStyle(
                color: _selectedIndex == 0 ? Colors.blue : Colors.white,
                fontWeight: _selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
              )),
          ),
          TextButton.icon(
            onPressed: () => setState(() => _selectedIndex = 1),
            icon: Icon(Icons.chat, 
              color: _selectedIndex == 1 ? Colors.blue : Colors.white),
            label: Text('Chats', 
              style: TextStyle(
                color: _selectedIndex == 1 ? Colors.blue : Colors.white,
                fontWeight: _selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
              )),
          ),
          TextButton.icon(
            onPressed: () => setState(() => _selectedIndex = 2),
            icon: Icon(Icons.videocam, 
              color: _selectedIndex == 2 ? Colors.blue : Colors.white),
            label: Text('Meetings', 
              style: TextStyle(
                color: _selectedIndex == 2 ? Colors.blue : Colors.white,
                fontWeight: _selectedIndex == 2 ? FontWeight.bold : FontWeight.normal,
              )),
          ),
          TextButton.icon(
            onPressed: () => setState(() => _selectedIndex = 3),
            icon: Icon(Icons.account_circle, 
              color: _selectedIndex == 3 ? Colors.blue : Colors.white),
            label: Text('Account', 
              style: TextStyle(
                color: _selectedIndex == 3 ? Colors.blue : Colors.white,
                fontWeight: _selectedIndex == 3 ? FontWeight.bold : FontWeight.normal,
              )),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
