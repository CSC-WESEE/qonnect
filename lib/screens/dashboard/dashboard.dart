import 'dart:io';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qonnect/apis/address_book/address_book.dart';
import 'package:qonnect/screens/dashboard/home/home_page.dart';
import 'package:qonnect/screens/dashboard/meetings/meetings.dart';
import 'package:qonnect/screens/dashboard/messaging/messaging.dart';
import 'package:qonnect/utils/LocalDB/local_db.dart';

List<Map<String, dynamic>> userInfo = [];

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>  {  
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getOwnerInfo();
  }

  void getOwnerInfo() async {
    userInfo = await DBHelper.getOwnerInfo();
    log(userInfo.toString(), name: "User Info");
  }

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
        actions:
            Platform.isAndroid
                ? []
                : [
                  TextButton.icon(
                    onPressed: () => setState(() => _selectedIndex = 0),
                    icon: Icon(
                      Icons.home,
                      color: _selectedIndex == 0 ? Colors.blue : Colors.white,
                    ),
                    label: Text(
                      'Home',
                      style: TextStyle(
                        color: _selectedIndex == 0 ? Colors.blue : Colors.white,
                        fontWeight:
                            _selectedIndex == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => _selectedIndex = 1),
                    icon: Icon(
                      Icons.chat,
                      color: _selectedIndex == 1 ? Colors.blue : Colors.white,
                    ),
                    label: Text(
                      'Chats',
                      style: TextStyle(
                        color: _selectedIndex == 1 ? Colors.blue : Colors.white,
                        fontWeight:
                            _selectedIndex == 1
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => _selectedIndex = 2),
                    icon: Icon(
                      Icons.videocam,
                      color: _selectedIndex == 2 ? Colors.blue : Colors.white,
                    ),
                    label: Text(
                      'Meetings',
                      style: TextStyle(
                        color: _selectedIndex == 2 ? Colors.blue : Colors.white,
                        fontWeight:
                            _selectedIndex == 2
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => _selectedIndex = 3),
                    icon: Icon(
                      Icons.account_circle,
                      color: _selectedIndex == 3 ? Colors.blue : Colors.white,
                    ),
                    label: Text(
                      'Account',
                      style: TextStyle(
                        color: _selectedIndex == 3 ? Colors.blue : Colors.white,
                        fontWeight:
                            _selectedIndex == 3
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
      ),
      bottomNavigationBar:
          !Platform.isAndroid
              ? null
              : NavigationBar(
                backgroundColor: Colors.deepPurple,
                onDestinationSelected: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                indicatorColor: Colors.white,
                selectedIndex: _selectedIndex,
                labelTextStyle: WidgetStatePropertyAll(
                  TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                destinations: const <Widget>[
                  NavigationDestination(
                    selectedIcon: Icon(Icons.home),
                    icon: Icon(Icons.home_outlined, color: Colors.lightBlue),
                    label: 'Home',
                  ),
                  NavigationDestination(
                    icon: Badge(
                      label: Text('3'),
                      child: Icon(Icons.message, color: Colors.lightBlue),
                    ),
                    label: 'Messages',
                  ),
                  NavigationDestination(
                    icon: Badge(
                      label: Text('2'),
                      child: Icon(
                        Icons.video_call_rounded,
                        color: Colors.lightBlue,
                      ),
                    ),
                    label: 'Meetings',
                  ),

                  NavigationDestination(
                    selectedIcon: Icon(Icons.account_circle),
                    icon: Icon(Icons.account_circle, color: Colors.lightBlue),
                    label: 'Account',
                  ),
                ],
              ),
      body: _pages[_selectedIndex],
    );
  }
}
